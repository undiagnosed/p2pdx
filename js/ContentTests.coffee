class ContentTests extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @table = new Table('#test')
        @update()

    handleLoad: ->
        @log "Handle Load"
        @table.initTable()
        @table.setData([["Hey"]])
        return false

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update
            @log "Updating Tests"
            #@table.initTable()
            @need_update = true
            
            query = """
            SELECT message.*, keyvalue.value AS cert_user_id FROM message
            LEFT JOIN json AS data_json USING (json_id)
            LEFT JOIN json AS content_json ON (
                data_json.directory = content_json.directory AND content_json.file_name = 'content.json'
            )
            LEFT JOIN keyvalue ON (keyvalue.key = 'cert_user_id' AND keyvalue.json_id = content_json.json_id)
            ORDER BY date_added DESC
            """
            Page.cmd "dbQuery", [query], (messages) =>
                data = []
                for message in messages
                    body = message.body.replace(/</g, "&lt;").replace(/>/g, "&gt;")  # Escape html tags in body
                    row = []
                    row.push(body)
                    data.push(row)
                   
                @table.setData(data)

        @log "tests content"

        h("div#Content.center", [
            h("div.starter-template", {afterCreate: Page.handleLoad}, [
                h("h1", "Tests")
                h("p.lead", "TODO")
                @table.render()
            ])
        ])

    lateinit: =>
        @log "init !!!!"

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentTests = ContentTests
