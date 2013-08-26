jQuery ->
  $('.datatable').dataTable
    aaSorting: [[0, "desc"]]
    bJQueryUI: true
    bServerSide: true
    sAjaxSource: $('.datatable').data('source')
    sDom: "<'row'<'col-6'f><'col-6'l>r>t<'row'<'col-6'i><'col-6'p>>"
    sPaginationType: "bootstrap"

  # Hack to make pagination work with bootstrap 3
  $('div.pagination ul').addClass 'pagination'
