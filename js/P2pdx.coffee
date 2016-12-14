window.h = maquette.h

class P2pdx extends ZeroFrame
    init: ->
        @params = {}
        @site_info = null
        @server_info = null
        @address = null
        @num_users = 0
        @num_msgs = 0
        @on_site_info = new Promise()
        @on_loaded = new Promise()

        @on_site_info.then =>
            # Load user data
            @updateSiteInfo
            #Page.projector.scheduleRender()

        #@addLine "inited!"

    createProjector: ->
        @log "createProjector()"
        @projector = maquette.createProjector()
        @home = new ContentHome()
        @tests = new ContentTests()
        @vitals = new ContentVitals()
        @symptoms = new ContentSymptoms()
        @visits = new ContentVisits()
        @diagnoses = new ContentDiagnoses()
        @medications = new ContentMedications()
        @learnmore = new ContentLearnMore()
        @header = new Header()

        if base.href.indexOf("?") == -1
            @route("")
        else
            @route(base.href.replace(/.*?\?/, ""))

        # @projector.replace($("#Head"), @header.render)
        @projector.replace(document.getElementById("Head"), @header.render)

    # Parse incoming requests from UiWebsocket server
    onRequest: (cmd, params) ->
        if cmd == "setSiteInfo" # Site updated
            @setSiteInfo(params)
        else if cmd == "wrapperPopState" # Site updated
            if params.state
                if not params.state.url
                    params.state.url = params.href.replace /.*\?/, ""
                @on_loaded.resolved = false
                document.body.className = ""
                window.scroll(window.pageXOffset, params.state.scrollTop or 0)
                @route(params.state.url or "")
        else
            @log "Unknown command", cmd, params

    route: (query) ->
        @params = Text.queryParse(query)
        @log "Route", @params

        # privileged URLS can only access when logged in
        if @params.urls[0] == "Tests" and Page.site_info?.cert_user_id
            content = @tests
        else if @params.urls[0] == "Vitals" and Page.site_info?.cert_user_id
            content = @vitals
        else if @params.urls[0] == "Symptoms" and Page.site_info?.cert_user_id
            content = @symptoms
        else if @params.urls[0] == "Visits" and Page.site_info?.cert_user_id
            content = @visits
        else if @params.urls[0] == "Diagnoses" and Page.site_info?.cert_user_id
            content = @diagnoses
        else if @params.urls[0] == "Medications" and Page.site_info?.cert_user_id
            content = @medications
        else if @params.urls[0] == "LearnMore"
            content = @learnmore
        else
            content = @home
        setTimeout ( => @content.update() ), 100
        if content and (@content != content)
            if @content
                @projector.detach(@content.render)
            @content = content
            @on_site_info.then =>
                # @projector.replace($("#Content"), @content.render)
                @projector.replace(document.getElementById("Content"), @content.render)

    setUrl: (url, mode="push") ->
        url = url.replace(/.*?\?/, "")
        @log "setUrl", @history_state["url"], "->", url
        if @history_state["url"] == url
            @content.update()
            return false
        @history_state["url"] = url
        if mode == "replace"
            @cmd "wrapperReplaceState", [@history_state, "", url]
        else
            @cmd "wrapperPushState", [@history_state, "", url]
        @route url
        return false

    handleLinkClick: (e) =>
        if e.which == 2
            # Middle click dont do anything
            return true
        else
            @log "save scrollTop", window.pageYOffset
            @history_state["scrollTop"] = window.pageYOffset
            @cmd "wrapperReplaceState", [@history_state, null]

            window.scroll(window.pageXOffset, 0)
            @history_state["scrollTop"] = 0

            @on_loaded.resolved = false
            document.body.className = ""

            @setUrl e.currentTarget.search
            return false

    handleLoad: =>
        @log "TABLE EVENT !!!"
        @content.handleLoad()
        return false

    renderContent: =>
        if @site_info
            return h("div#Content", @content.render())
        else
            return h("div#Content")

    sendMessage: =>
        if not Page.site_info.cert_user_id  # No account selected, display error
            Page.cmd "wrapperNotification", ["info", "Please, select your account."]
            return false

        document.getElementById("message").disabled = true
        inner_path = "data/users/#{@site_info.auth_address}/data.json"  # This is our data file

        # Load our current messages
        @cmd "fileGet", {"inner_path": inner_path, "required": false}, (data) =>
            if data  # Parse if already exits
                data = JSON.parse(data)
            else  # Not exits yet, use default data
                data = { "message": [] }

            # Add the message to data
            data.message.push({
                "body": document.getElementById("message").value,
                "date_added": (+new Date)
            })

            # Encode data array to utf8 json text
            json_raw = unescape(encodeURIComponent(JSON.stringify(data, undefined, '\t')))

            # Write file to disk
            @cmd "fileWrite", [inner_path, btoa(json_raw)], (res) =>
                if res == "ok"
                    # Publish the file to other users
                    @cmd "sitePublish", {"inner_path": inner_path}, (res) =>
                        document.getElementById("message").disabled = false
                        document.getElementById("message").value = ""  # Reset the message input
                        document.getElementById("message").focus()
                        @loadMessages()
                else
                    @cmd "wrapperNotification", ["error", "File write error: #{res}"]
                    document.getElementById("message").disabled = false

        return false


    loadMessages: (mode="normal") ->
        query = """
            SELECT message.*, keyvalue.value AS cert_user_id FROM message
            LEFT JOIN json AS data_json USING (json_id)
            LEFT JOIN json AS content_json ON (
                data_json.directory = content_json.directory AND content_json.file_name = 'content.json'
            )
            LEFT JOIN keyvalue ON (keyvalue.key = 'cert_user_id' AND keyvalue.json_id = content_json.json_id)
            ORDER BY date_added DESC
        """
        if mode != "nolimit"
            query += " LIMIT 60"
        @num_msgs = 0
        @cmd "dbQuery", [query], (messages) =>
            document.getElementById("messages").innerHTML = ""  # Always start with empty messages
            message_lines = []
            for message in messages
                if message.date_added > (+new Date) + 60*3 then continue
                body = message.body.replace(/</g, "&lt;").replace(/>/g, "&gt;")  # Escape html tags in body
                added = new Date(message.date_added)
                @num_msgs = @num_msgs + 1
                message_lines.push "<li><small title='#{added}'>#{Time.since(message.date_added/1000)}</small> <b style='color: #{Text.toColor(message.cert_user_id)}'>#{message.cert_user_id.replace('@zeroid.bit', '')}</b>: #{body}</li>"
            if mode != "nolimit"
                message_lines.push("<li><a href='#More' onclick='this.style.opacity = 0.4; return Page.loadMessages(\"nolimit\"); '>Load more messages...</a></li>")
            document.getElementById("messages").innerHTML = message_lines.join("\n")
        return false


    addLine: (line) ->
        messages = document.getElementById("messages")
        messages.innerHTML = "<li>#{line}</li>"+messages.innerHTML

    updateServerInfo: =>
        @cmd "serverInfo", {}, (server_info) =>
            @setServerInfo(server_info)

    setServerInfo: (server_info) ->
        @server_info = server_info
        if @server_info.rev < 1400
            @cmd "wrapperNotification", ["error", "This site requries ZeroNet 0.4.0+<br>Please delete the site from your current client, update it, then add again!"]

    updateSiteInfo: (cb=null) =>
        @cmd "siteInfo", {}, (site_info) =>
            @address = site_info.address
            @setSiteInfo(site_info)

    setSiteInfo: (site_info) ->
        if not @site_info
            @site_info = site_info
            @on_site_info.resolve()
        if site_info.event?[0] == "cert_changed"
            @log "cert changed event"
            @log site_info.cert_user_id
            @log Page.site_info.cert_user_id
            @site_info = site_info
            @setUrl("?Home")
            if Page.site_info.cert_user_id
                @log Page.site_info.cert_user_id
	        Page.projector.scheduleRender()
           
    onOpenWebsocket: (e) =>
        @updateServerInfo()
        @updateSiteInfo()


window.Page = new P2pdx()
window.Page.createProjector()
