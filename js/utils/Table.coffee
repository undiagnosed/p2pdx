class Table extends Class
    constructor: (@table_id) ->
        @data = []
        @table = null
        @table_inited = false

    initTable: =>
        @log "init table"
        @log @table_id.substring(1, @table_id.length)
        #if @table_inited == false
        @table_inited = true
        @table = $(@table_id).DataTable( 
            data: @data,
            columns: [
                title: "Test" 
            ]
        )
        return

    getSelectedRow: =>
        return @table.row('.selected')

    setData: (data) ->
        @data = data
        @table.clear().rows.add(@data).draw()
        return

    render: =>
        #@initTable()
        #@table.setData([["Hey"]])
        h("table.display", {id: @table_id.substring(1, @table_id.length)})

    init: =>
        @log "TABLE INIT!!!"

window.Table = Table
