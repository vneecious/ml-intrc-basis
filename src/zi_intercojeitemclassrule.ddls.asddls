/**
 * This view identifies whether a given Journal Entry (JE) Item is classified by a Rule (from ZI_IntercoClassificationRule)
 * or by an Exemption and Exemption Rules (from ZI_IntercoExemptionRuleFlat).
 *
 * For performance optimization, the view does not attempt to classify items that lack assigned P&L data.
 *
 * Note: Since both Classification Rules and Exemption Rules treat empty fields as a wildcard (*), it is possible—and highly probable—that
 * multiple rules or exemptions may apply to a single JE Item.
 *
 * The purpose of this view is not to determine the best match; that responsibility lies with ZI_IntercoJEItemClassMatch.
 * Instead, this view provides a comprehensive list of all possible rules and exemptions that could apply to a JE Item.
 *
 * Intercompany Basis View Hierarchy:
 * ZR_IntercoJEItemClass
 *  - ZI_IntercoJEItemClass
 *      - ZI_IntercoJEItemClassMatch
 *          - ZI_IntercoJEItemClassRule <------- CURRENT VIEW
 *              - ZI_IntercoJEItemPandL
 *                  - ZI_IntercoJEItem
 */
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Intercompany / Basis: JE Item Classified for Interco'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define view entity ZI_IntercoJEItemClassRule
  as select from    ZI_IntercoJEItemPandL
    left outer join ZI_IntercoExemptionRuleFlat  as J_Exemption          on  ZI_IntercoJEItemPandL.PandLL0Id   is not initial
                                                                         and ZI_IntercoJEItemPandL.PostingDate between J_Exemption.ValidFrom and J_Exemption.ValidTo
                                                                         and (
                                                                            J_Exemption.CompanyCode            is initial
                                                                            or J_Exemption.CompanyCode         =       ZI_IntercoJEItemPandL.CompanyCode
                                                                          )

                                                                         and (
                                                                            J_Exemption.CostCenter             is initial
                                                                            or J_Exemption.CostCenter          =       ZI_IntercoJEItemPandL.CostCenter
                                                                          )
                                                                         and (
                                                                            J_Exemption.ProfitCenter           is initial
                                                                            or J_Exemption.ProfitCenter        =       ZI_IntercoJEItemPandL.ProfitCenter
                                                                          )
                                                                         and (
                                                                            J_Exemption.GLAccount              is initial
                                                                            or J_Exemption.GLAccount           =       ZI_IntercoJEItemPandL.GLAccount
                                                                          )
    left outer join ZI_IntercoClassificationRule as J_ClassificationRule on(
      J_Exemption.ExternalID                    is null
      and ZI_IntercoJEItemPandL.PandLL0Id       is not initial
      and ZI_IntercoJEItemPandL.PostingDate     between J_ClassificationRule.ValidFrom and J_ClassificationRule.ValidTo

      // Rule Input
      and(
        J_ClassificationRule.CompanyCode        =       ZI_IntercoJEItemPandL.CompanyCode
        or J_ClassificationRule.CompanyCode     is initial
      )
      and(
        J_ClassificationRule.CcStdHierArea      =       ZI_IntercoJEItemPandL.CostCenterStandardHierArea
        or J_ClassificationRule.CcStdHierArea   is initial
      )
      and(
        J_ClassificationRule.ProfitCenter       =       ZI_IntercoJEItemPandL.ProfitCenter
        or J_ClassificationRule.ProfitCenter    is initial
      )
      and(
        J_ClassificationRule.CcAllocation       =       ZI_IntercoJEItemPandL.CCAllocation
        or J_ClassificationRule.CcAllocation    is initial
      )
      and(
        J_ClassificationRule.CcConsolidation    =       ZI_IntercoJEItemPandL.CCConsolidation
        or J_ClassificationRule.CcConsolidation is initial
      )
      and(
        J_ClassificationRule.PAndLID            is initial
        or(
          J_ClassificationRule.PAndLID          =       ZI_IntercoJEItemPandL.PandLL0Id
          or J_ClassificationRule.PAndLID       =       ZI_IntercoJEItemPandL.PandLL1Id
          or J_ClassificationRule.PAndLID       =       ZI_IntercoJEItemPandL.PandLL2Id
          or J_ClassificationRule.PAndLID       =       ZI_IntercoJEItemPandL.PandLL3Id
          or J_ClassificationRule.PAndLID       =       ZI_IntercoJEItemPandL.PandLL4Id
          or J_ClassificationRule.PAndLID       =       ZI_IntercoJEItemPandL.PandLL5Id
        )
      )
    )

  //  association [0..*] to ZI_IntercoClassificationRule as _ClassificationRule on _ClassificationRule.ID = $projection.ClassificationRuleID

{
  key ZI_IntercoJEItemPandL.SourceLedger,
  key ZI_IntercoJEItemPandL.CompanyCode,
  key ZI_IntercoJEItemPandL.FiscalYear,
  key ZI_IntercoJEItemPandL.FiscalPeriod,
  key ZI_IntercoJEItemPandL.AccountingDocument,
  key ZI_IntercoJEItemPandL.LedgerGLLineItem,
  key ZI_IntercoJEItemPandL.Ledger,

      ZI_IntercoJEItemPandL.Segment,
      ZI_IntercoJEItemPandL.AccountingDocumentType,
      ZI_IntercoJEItemPandL.AccountingDocumentItem,
      ZI_IntercoJEItemPandL.DebitCreditCode,
      ZI_IntercoJEItemPandL.AccountingDocumentCategory,
      ZI_IntercoJEItemPandL.LedgerFiscalYear,
      ZI_IntercoJEItemPandL.ClearingAccountingDocument,
      ZI_IntercoJEItemPandL.ClearingJournalEntry,
      ZI_IntercoJEItemPandL.ClearingDate,
      ZI_IntercoJEItemPandL.ClearingDocFiscalYear,
      ZI_IntercoJEItemPandL.ClearingJournalEntryFiscalYear,
      ZI_IntercoJEItemPandL.IsOpenItemManaged,
      ZI_IntercoJEItemPandL.TransactionCurrency,
      ZI_IntercoJEItemPandL.AmountInTransactionCurrency,
      ZI_IntercoJEItemPandL.CompanyCodeCurrency,
      ZI_IntercoJEItemPandL.AmountInCompanyCodeCurrency,
      ZI_IntercoJEItemPandL.GlobalCurrency,
      ZI_IntercoJEItemPandL.AmountInGlobalCurrency,
      ZI_IntercoJEItemPandL.CreationDate,
      ZI_IntercoJEItemPandL.FiscalYearPeriod,
      ZI_IntercoJEItemPandL.OriginObjectType,

      ZI_IntercoJEItemPandL.ProfitCenter,
      ZI_IntercoJEItemPandL.PostingDate,
      ZI_IntercoJEItemPandL.CreationDateTime,
      ZI_IntercoJEItemPandL.CostCenter,
      ZI_IntercoJEItemPandL.ControllingArea,
      ZI_IntercoJEItemPandL.PaymentType,
      ZI_IntercoJEItemPandL.CostCenterStandardHierArea,
      ZI_IntercoJEItemPandL.ChartOfAccounts,
      ZI_IntercoJEItemPandL.GLAccount,
      ZI_IntercoJEItemPandL.GLAccountHierarchy,
      ZI_IntercoJEItemPandL.GLAccountHierarchyNode,
      ZI_IntercoJEItemPandL.GLAccountParentNode,
      ZI_IntercoJEItemPandL.CCConsolidationHierarchy,
      ZI_IntercoJEItemPandL.CCConsolidationHierarchyNode,
      ZI_IntercoJEItemPandL.CCConsolidationParentNode,
      ZI_IntercoJEItemPandL.CCConsolidation,
      ZI_IntercoJEItemPandL.PCConsolidationHierarchy,
      ZI_IntercoJEItemPandL.PCConsolidationHierarchyNode,
      ZI_IntercoJEItemPandL.PCConsolidationParentNode,
      ZI_IntercoJEItemPandL.PCConsolidation,
      ZI_IntercoJEItemPandL.CCAllocationHierarchy,
      ZI_IntercoJEItemPandL.CCAllocationHierarchyNode,
      ZI_IntercoJEItemPandL.CCAllocationParentNode,
      ZI_IntercoJEItemPandL.CCAllocation,
      ZI_IntercoJEItemPandL.zagrup_cuentas,
      ZI_IntercoJEItemPandL.zconsolidation,
      ZI_IntercoJEItemPandL.CCStdHierarchy,
      ZI_IntercoJEItemPandL.CCStdParentNode,
      ZI_IntercoJEItemPandL.PCBusinessUnit,
      ZI_IntercoJEItemPandL.PCSubBusinessUnitGroup,
      ZI_IntercoJEItemPandL.PCSubBusinessUnit,
      ZI_IntercoJEItemPandL.PandLL0Id,
      ZI_IntercoJEItemPandL.PandLL1Id,
      ZI_IntercoJEItemPandL.PandLL2Id,
      ZI_IntercoJEItemPandL.PandLL3Id,
      ZI_IntercoJEItemPandL.PandLL4Id,
      ZI_IntercoJEItemPandL.PandLL5Id,
      J_ClassificationRule.ID     as ClassificationRuleID,
      J_ClassificationRule.RuleID as ClassificationRuleExtID,
      J_ClassificationRule.Score  as ClassificationRuleScore,
      J_Exemption.ID              as ExemptionID,
      J_Exemption.ExternalID      as ExemptionExtID,
      J_Exemption.Score           as ExemptionScore,

      /* Associations */
      ZI_IntercoJEItemPandL._CCAllocationHierarchyNode,
      ZI_IntercoJEItemPandL._CCConsolidationHierarchyNode,
      ZI_IntercoJEItemPandL._CCConsolidationParentNode,
      ZI_IntercoJEItemPandL._GLAccountHierarchyNode,
      ZI_IntercoJEItemPandL._GLAccountParentNode,
      ZI_IntercoJEItemPandL._IntercoCompanyCode,
      ZI_IntercoJEItemPandL._MT005,
      ZI_IntercoJEItemPandL._PCConsolidationHierarchyNode,
      ZI_IntercoJEItemPandL._PCConsolidationParentNode,
      ZI_IntercoJEItemPandL._PCHierarchyFlat,

      //      _ClassificationRule
      ZI_IntercoJEItemPandL._CCAllocationParentNode,
      ZI_IntercoJEItemPandL._CurrentCostCenter,
      ZI_IntercoJEItemPandL._CurrentProfitCenter,
      ZI_IntercoJEItemPandL._CCStdHierarchyNode,
      ZI_IntercoJEItemPandL._CCStdParentNode
}
