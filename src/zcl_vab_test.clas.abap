class zcl_vab_test definition
  public
  final
  create public .

  public section.

    interfaces if_rap_query_provider .
  protected section.
  private section.
endclass.



class zcl_vab_test implementation.


  method if_rap_query_provider~select.

    data results type table of zi_intjournalentryclass_2.

    "  Apply OData requested $orderby, $select AND $filter
    data(lt_sort_elements) = io_request->get_sort_elements( ).
    data(lt_request_elements) = io_request->get_requested_elements( ).
    data(lt_aggr_elements) = io_request->get_aggregation( )->get_aggregated_elements( ).
    data(lt_groupped_elements) = io_request->get_aggregation( )->get_grouped_elements( ).
    data(lv_offset) = io_request->get_paging( )->get_offset( ).
    data(lv_pagesize) = io_request->get_paging( )->get_page_size( ).
    data lv_orderby type string.

    " $orderby
    loop at lt_sort_elements into data(sort_element).
      if not line_exists( lt_request_elements[ table_line = sort_element-element_name ] ).
        continue.
      endif.
      lv_orderby = lv_orderby &&
                   cond string(  when lv_orderby is initial then `` else `, ` ) &&
                   sort_element-element_name &&
                   cond string( when sort_element-descending = abap_true then ` descending` else space ).
    endloop.
    if sy-subrc <> 0.
      lv_orderby = reduce string( init r = ``
                                  for req_element in lt_request_elements
                                  next r = r &&
                                  cond string( when r is not initial then `, ` else space ) &&
                                  req_element ).
    endif.

    " aggregations
    loop at lt_aggr_elements into data(aggr_element).
      delete lt_request_elements where table_line = aggr_element-result_element.
      data(lv_aggregation) = |{ aggr_element-aggregation_method }( { aggr_element-input_element } ) as { aggr_element-result_element }|.
      append lv_aggregation to lt_request_elements.
    endloop.

    " $select
    data(lv_columns) = reduce string( init r = ``
                            for req_element in lt_request_elements
                            next r = r &&
                            cond string( when r is not initial then `, ` else space ) &&
                            req_element ).

    " $filter
    data(lt_parameters) = io_request->get_parameters( ).

    data(lv_fixed_where) = reduce string( init p = ``
                             for parameter in lt_parameters
                             next p = p &&
                             cond string( when p is not initial then ` AND ` else space ) &&
                             |{ parameter-parameter_name+2 } = '{ parameter-value }'| ). " +2 IS ONLY TO IGNORE THE PREFIX P_
    data(lv_variable_where) = io_request->get_filter( )->get_as_sql_string( ).
    data(lv_where) = lv_fixed_where &&
                     cond #( when lv_variable_where is initial then `` else ` AND ` )  &&
                     lv_variable_where.
    " grouping
    data(lv_groupby) = concat_lines_of( table = lt_groupped_elements sep = ', ' ).

    lv_pagesize = cond #( when lv_pagesize = if_rap_query_paging=>page_size_unlimited then 1000 else lv_pagesize ).

    if io_request->is_data_requested(  ).
      select distinct (lv_columns)
          from ZR_IntercoJEItemClass as results
          where (lv_where)
              group by (lv_groupby)
              order by (lv_orderby)
          into corresponding fields of table @results
          offset @lv_offset
          up to @lv_pagesize rows.
    endif.

    if io_request->is_total_numb_of_rec_requested( ).
      select count( * )
            from ZR_IntercoJEItemClass as results
            where (lv_where)
            into @data(count).
    endif.

    io_response->set_data( results ).
    io_response->set_total_number_of_records( count ).

  endmethod.
endclass.
