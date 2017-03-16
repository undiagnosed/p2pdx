class ContentHome extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @update()
        @num_users_total = null
        @user_list_recent = new UserList("recent")
        @user_list_recent.limit = 5

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update or not @num_users_total
            @num_peers = (Page.site_info["peers"] or "n/a")
            Page.cmd "dbQuery", "SELECT COUNT(*) AS num FROM user", (res) =>
                @num_users_total = res[0]["num"]
                Page.projector.scheduleRender()
        if @need_update
            @log "Updating"
            @user_list_recent?.need_update = true
            @need_update = false
            
            #num_users_query = "SELECT value FROM keyvalue WHERE KEY=\'cert_user_id\'"
            #Page.cmd "dbQuery", [num_users_query], (res) =>
            #    if not res.error and res.length != 0 # Db not ready yet or No user found
            #        @num_users = res.length #row["count"]
    
            #Page.cmd "dbQuery", ["SELECT * FROM message"], (res) =>
            #     if not res.error and res.length != 0 # Db not ready yet or No user found
            #        @num_msgs = res.length

        @log "home content"

        h("div#Content.center", [
            #h("div.starter-template", [
            h("div.jumbotron", [
                h("div.container.text-center", [
                    h("h1", "Welcome to p2pdx")
                    h("p", "Take action and help improve medical diagnostics by sharing your data.")
                    h("a.btn.btn-primary.btn-lg", {href: "?LearnMore", id: "learnmore", onclick: Page.handleLinkClick}, "Learn More")
                    #h("p", @num_users, " registered users")
                    #h("p", @num_msgs, " messages")
                ])
            ])

            h("div.container", [
                h("div.row", [
                    h("div.col-md-3", [
                        h("div.panel.panel-primary", [
                            h("div.panel-heading", [
                                h("h3.panel-title", "New Users")
                            ])
                            h("div.panel-body", [
                                h("div.list-group", [
                                    @user_list_recent.render("top")
                                    #h("a.list-group-item", "undiagnosed")
                                    #h("a.list-group-item", "yoman5000")
                                    #h("a.list-group-item", "fredsmith")
                                    #h("a.list-group-item", "alah")
                                    #h("a.list-group-item", "johnny")
                                ])
                                h("div.text-right", [
                                    h("a", {href: "?Users", id: "users", onclick: @handleSelectUserClick}, "View All #{@num_users_total} Users ", [
                                        h("i.fa.fa-arrow-circle-right")
                                    ])
                                ])
                            ])
                        ])
                    ])
                    h("div.col-md-3", [
                        h("div.panel.panel-primary", [
                            h("div.panel-heading", [
                                h("h3.panel-title", "Top Tests")
                            ])
                            h("div.panel-body", [
                                h("div.list-group", [
                                    h("a.list-group-item", "WBC")
                                    h("a.list-group-item", "RBC")
                                    h("a.list-group-item", "CD4 %")
                                    h("a.list-group-item", "Lyme IgM")
                                    h("a.list-group-item", "Quant IgG")
                                ])
                                h("div.text-right", [
                                    h("a", "View All 1200 Tests ", [
                                        h("i.fa.fa-arrow-circle-right")
                                    ])
                                ])
                            ])
                        ])
                    ])
                    h("div.col-md-3", [
                        h("div.panel.panel-primary", [
                            h("div.panel-heading", [
                                h("h3.panel-title", "Top Symptoms")
                            ])
                            h("div.panel-body", [
                                h("div.list-group", [
                                    h("a.list-group-item", "Fatigue")
                                    h("a.list-group-item", "Dry Mouth")
                                    h("a.list-group-item", "Joint Pain")
                                    h("a.list-group-item", "Headache")
                                    h("a.list-group-item", "Muscle Pain")
                                ])
                                h("div.text-right", [
                                    h("a", "View All 250 Symptoms ", [
                                        h("i.fa.fa-arrow-circle-right")
                                    ])
                                ])
                            ])
                        ])
                    ])
                    h("div.col-md-3", [
                        h("div.panel.panel-primary", [
                            h("div.panel-heading", [
                                h("h3.panel-title", "Top Diagnoses")
                            ])
                            h("div.panel-body", [
                                h("div.list-group", [
                                    h("a.list-group-item", "ME/CFS")
                                    h("a.list-group-item", "Diabetes")
                                    h("a.list-group-item", "Lupus")
                                    h("a.list-group-item", "Cancer")
                                    h("a.list-group-item", "Heart Disease")
                                ])
                                h("div.text-right", [
                                    h("a", "View All 120 Diagnoses ", [
                                        h("i.fa.fa-arrow-circle-right")
                                    ])
                                ])
                            ])
                        ])
                    ])
                ])
                h("hr")
                h("footer", [
                    h("p", "This site currently served by ", @num_peers, " peers, without any central server.")
                ])
            ])
        ])
    

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentHome = ContentHome
