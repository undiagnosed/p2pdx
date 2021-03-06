class ContentDiagnoses extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @update()

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update
            @log "Updating Diagnoses"
            @need_update = false
            

        @log "diagnoses content"

        h("div#Content.center", [
            h("div.starter-template", [
                h("h1", "Diagnoses")
                h("p.lead", "TODO")
            ])
        ])

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentDiagnoses = ContentDiagnoses
