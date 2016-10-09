class ContentHome extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @update()

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update
            @log "Updating"
            @need_update = false
            @num_peers = (Page.site_info["peers"] or "n/a")

            num_users_query = "SELECT value FROM keyvalue WHERE KEY=\'cert_user_id\'"
            Page.cmd "dbQuery", [num_users_query], (res) =>
                if not res.error and res.length != 0 # Db not ready yet or No user found
                    @num_users = res.length #row["count"]
    
            Page.cmd "dbQuery", ["SELECT * FROM message"], (res) =>
                 if not res.error and res.length != 0 # Db not ready yet or No user found
                    @num_msgs = res.length

        @log "home content"

        h("div#Content.center", [
            h("div.starter-template", [
                h("h1", "Welcome to p2pdx")
                h("p.lead", "Take action and help improve medical diagnostics by sharing your data.")
                h("p", "This site currently served by ", @num_peers, " peers, without any central server.")
                h("p", @num_users, " registered users")
                h("p", @num_msgs, " messages")
            ])
        ])

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentHome = ContentHome
