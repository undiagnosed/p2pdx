window.h = maquette.h

class P2pdx extends ZeroFrame
    init: ->
        @params = {}
        @site_info = null
        @server_info = null
        @address = null
        @num_users = 0
        @num_msgs = 0
        @user = false
        @userdb = "1EU9ub2jUWgWJdMKHUGgHttVPqLSaKhjYy"

        @on_site_info = new Promise()
        @on_local_storage = new Promise()
        @on_user_info = new Promise()
        @on_loaded = new Promise()
        @local_storage = null

        @on_site_info.then =>
            # Load user data
            @checkUser =>
                @on_user_info.resolve()

            #@updateSiteInfo # undo this comment if it doesn't work
            #Page.projector.scheduleRender()

            if "Merger:P2pdx" not in @site_info.settings.permissions
                @cmd "wrapperPermissionAdd", "Merger:P2pdx", =>
                    @updateSiteInfo =>
                        @content.update()

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
        @users = new ContentUsers()
        @content_create_profile = new ContentCreateProfile()
        @header = new Header()

        if base.href.indexOf("?") == -1
            @route("")
        else
            @route(base.href.replace(/.*?\?/, ""))

        # @projector.replace($("#Head"), @header.render)
        @projector.replace(document.getElementById("Head"), @header.render)
        @loadLocalStorage()

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
        if @params.urls[0] == "Create+profile"
            content = @content_create_profile
        else if @params.urls[0] == "Tests" and Page.site_info?.cert_user_id
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
        else if @params.urls[0] == "Users"
            content = @users
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

    updateServerInfo: =>
        @cmd "serverInfo", {}, (server_info) =>
            @setServerInfo(server_info)

    setServerInfo: (server_info) ->
        @server_info = server_info
        if @server_info.rev < 1400
            @cmd "wrapperNotification", ["error", "This site requries ZeroNet 0.4.0+<br>Please delete the site from your current client, update it, then add again!"]
        @projector.scheduleRender()

    updateSiteInfo: (cb=null) =>
        on_site_info = new Promise()
        @cmd "mergerSiteList", {}, (merged_sites) =>
            @merged_sites = merged_sites
            # Add userdb if not seeded yet
            on_site_info.then =>
                if "Merger:P2pdx" in @site_info.settings.permissions and not @merged_sites[@userdb]
                    @cmd "mergerSiteAdd", @userdb
                cb?(true)
        @cmd "siteInfo", {}, (site_info) =>
            @address = site_info.address
            @setSiteInfo(site_info)
            on_site_info.resolve()

    setSiteInfo: (site_info) ->
        # First update
        if site_info.address == @address
            if not @site_info  # First site info
                @site_info = site_info
                @on_site_info.resolve()
            @site_info = site_info
            if site_info.event?[0] == "cert_changed"
                @checkUser (found) =>
                    if Page.site_info.cert_user_id and not found
                        @setUrl "?Create+profile" #?Create+profile
                    @content.update()

        if site_info.event?[0] == "file_done"
            file_name = site_info.event[1]
            if file_name.indexOf(site_info.auth_address) != -1 and Page.user?.auth_address != site_info.auth_address
                # User's data arrived and not autheticated yet
                @checkUser =>
                    @content.update()
            else if not @merged_sites[site_info.address] and site_info.address != @address
                # New site added
                @log "New site added:", site_info.address
                @updateSiteInfo =>
                    @content.update()
            else if file_name.indexOf(site_info.auth_address) != -1
                # User's data changed, update immedietly
                @content.update()
            else if not file_name.endsWith("content.json") or file_name.indexOf(@userdb) != -1
                # Check only on data changes on hub sites and every file on userdb
                if site_info.tasks > 100
                    RateLimit 3000, @content.update
                else if site_info.tasks > 20
                    RateLimit 1000, @content.update
                else
                    RateLimit 500, @content.update

    needSite: (address, cb) =>
        if @merged_sites[address]
            cb?(true)
        else
            Page.cmd "mergerSiteAdd", address, cb
           
    checkUser: (cb=null) =>
        @log "Find hub for user", @site_info.cert_user_id
        if not @site_info.cert_user_id
            @user = new AnonUser()
            @user.updateInfo(cb)
            return false

        Page.cmd "dbQuery", ["SELECT * FROM json WHERE directory = :directory AND user_name IS NOT NULL AND file_name = 'data.json' AND intro IS NOT NULL", {directory: "data/users/#{@site_info.auth_address}"}], (res) =>
            if res?.length > 0
                @log "found user"
                @user = new User({hub: res[0]["hub"], auth_address: @site_info.auth_address})
                @user.row = res[0]
                for row in res
                    if row.site == row.hub
                        @user.row = row
                @log "Choosen site for user", @user.row.site, @user.row
                @user.updateInfo(cb)
            else
                # No currently seeded user with that cert_user_id
                @log "No user with that cert_id"
                @user = new AnonUser()
                @user.updateInfo()
                # Check in the userdb and start add the user's hub if necessary
                @queryUserdb @site_info.auth_address, (user) =>
                    if user
                        @log "found user"
                        if not @merged_sites[user.hub]
                            @log "Profile not seeded, but found in the userdb", user
                            Page.cmd "mergerSiteAdd", user.hub, =>  # Start download user's hub
                                cb?(true)
                        else
                            cb?(true)
                    else
                        @log "no profile"
                        # User selected, but no profile yet
                        cb?(false)

            Page.projector.scheduleRender()

    # Look for user in the userdb
    queryUserdb: (auth_address, cb) =>
        query = """
            SELECT
             CASE WHEN user.auth_address IS NULL THEN REPLACE(json.directory, "data/userdb/", "") ELSE user.auth_address END AS auth_address,
             CASE WHEN user.cert_user_id IS NULL THEN json.cert_user_id ELSE user.cert_user_id END AS cert_user_id,
             *
            FROM user
            LEFT JOIN json USING (json_id)
            WHERE
             user.auth_address = :auth_address OR
             json.directory = :directory
            LIMIT 1
        """
        Page.cmd "dbQuery", [query, {auth_address: auth_address, directory: "data/userdb/"+auth_address}], (res) =>
            if res?.length > 0
                cb?(res[0])
            else
                cb?(false)

    loadLocalStorage: ->
        @on_site_info.then =>
            @logStart "Loaded localstorage"
            @cmd "wrapperGetLocalStorage", [], (@local_storage) =>
                @logEnd "Loaded localstorage"
                @local_storage ?= {}
                @local_storage.followed_users ?= {}
                @on_local_storage.resolve(@local_storage)


    saveLocalStorage: (cb=null) ->
        @logStart "Saved localstorage"
        if @local_storage
            @cmd "wrapperSetLocalStorage", @local_storage, (res) =>
                @logEnd "Saved localstorage"
                cb?(res)

    onOpenWebsocket: (e) =>
        @updateServerInfo()
        @updateSiteInfo()


window.Page = new P2pdx()
window.Page.createProjector()
