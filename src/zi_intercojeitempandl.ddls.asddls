/**
 * This View is designed to add P&L data to the Intercompany JE Items.
 * Intercompany Basis View Hierarchy:
 * ZR_IntercoJEItemClass
 *  - ZI_IntercoJEItemClass
 *      - ZI_IntercoJEItemClassMatch
 *          - ZI_IntercoJEItemClassRule
 *              - ZI_IntercoJEItemPandL <------- CURRENT VIEW
 *                  - ZI_IntercoJEItem
 *
 */
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Intercompany / Basis: Journal Entry Item w/ P&L'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define view entity ZI_IntercoJEItemPandL
  as select from ZI_IntercoJEItem
  association [0..1] to Z_PNL_MT005 as _MT005 on _MT005.zagrup_cuentas      = $projection.GLAccountParentNode
                                              and(
                                                (
                                                  $projection.CostCenter    is not initial
                                                  and _MT005.zconsolidation = $projection.CCConsolidationParentNode
                                                )
                                                or(
                                                  $projection.CostCenter    is initial
                                                  and _MT005.zconsolidation = $projection.PCConsolidationParentNode
                                                )
                                              )
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key FiscalPeriod,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,

      Segment,
      AccountingDocumentType,
      AccountingDocumentItem,
      DebitCreditCode,
      AccountingDocumentCategory,
      LedgerFiscalYear,
      ClearingAccountingDocument,
      ClearingJournalEntry,
      ClearingDate,
      ClearingDocFiscalYear,
      ClearingJournalEntryFiscalYear,
      IsOpenItemManaged,
      TransactionCurrency,
      AmountInTransactionCurrency,
      CompanyCodeCurrency,
      AmountInCompanyCodeCurrency,
      GlobalCurrency,
      AmountInGlobalCurrency,
      CreationDate,
      FiscalYearPeriod,
      OriginObjectType,

      ProfitCenter,
      PostingDate,
      CreationDateTime,
      CostCenter,
      ControllingArea,
      PaymentType,
      CostCenterStandardHierArea,
      ChartOfAccounts,
      GLAccount,
      GLAccountHierarchy,
      GLAccountHierarchyNode,
      GLAccountParentNode,
      // CC Consolidation
      ZI_IntercoJEItem.CCConsolidationHierarchy,
      CCConsolidationHierarchyNode,
      CCConsolidationParentNode,
      cast( _CCConsolidationParentNode.HierarchyNodeVal as zint_cc_cons ) as CCConsolidation,
      // PC Consolidation
      PCConsolidationHierarchy,
      PCConsolidationHierarchyNode,
      PCConsolidationParentNode,
      _PCConsolidationParentNode.HierarchyNodeVal                         as PCConsolidation,
      // CC Allocation
      CCAllocationHierarchy,
      CCAllocationHierarchyNode,
      CCAllocationParentNode,
      cast( _CCAllocationParentNode.HierarchyNodeVal as zint_cc_alloc)    as CCAllocation,
      // CC Std Hierarchy
      ZI_IntercoJEItem.CCStdHierarchy,
      ZI_IntercoJEItem.CCStdParentNode,
      // PC Std Hierarchy
      PCBusinessUnit,
      PCSubBusinessUnitGroup,
      PCSubBusinessUnit,
      _MT005.zagrup_cuentas,
      _MT005.zconsolidation,
      _MT005.IdL0                                                         as PandLL0Id,
      _MT005.IdL1                                                         as PandLL1Id,
      _MT005.IdL2                                                         as PandLL2Id,
      _MT005.IdL3                                                         as PandLL3Id,
      _MT005.IdL4                                                         as PandLL4Id,
      _MT005.IdL5                                                         as PandLL5Id,
      /* Associations */
      _CCAllocationParentNode,
      _CCAllocationHierarchyNode,
      _CCConsolidationHierarchyNode,
      _CCConsolidationParentNode,
      _GLAccountHierarchyNode,
      _GLAccountParentNode,
      _IntercoCompanyCode,
      _PCConsolidationHierarchyNode,
      _PCConsolidationParentNode,
      _PCHierarchyFlat,
      _CCStdHierarchyNode,
      _CCStdParentNode,
      _CurrentCostCenter,
      _CurrentProfitCenter,
      _MT005

}
