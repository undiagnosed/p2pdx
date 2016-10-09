class ContentSymptoms extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @update()

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update
            @log "Updating Symptoms"
            @need_update = false
            

        @log "symptoms content"

        h("div#Content.center", [
            h("div.starter-template", [
                h("h1", "Symptoms")
                h("p.lead", "TODO")
            ])
        ])

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentSymptoms = ContentSymptoms
