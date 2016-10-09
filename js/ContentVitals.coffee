class ContentVitals extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @update()

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update
            @log "Updating Vitals"
            @need_update = false
            

        @log "vitals content"

        h("div#Content.center", [
            h("div.starter-template", [
                h("h1", "Vitals")
                h("p.lead", "TODO")
            ])
        ])

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentVitals = ContentVitals
