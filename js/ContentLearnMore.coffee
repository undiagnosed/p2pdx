class ContentLearnMore extends Class
    constructor: ->
        @loaded = true
        @need_update = false
        @update()

    render: =>
        if @loaded and not Page.on_loaded.resolved then Page.on_loaded.resolve()
        if @need_update
            @log "Updating Learn More"
            @need_update = false
            

        @log "learn more content"

        h("div#Content.center", [
            h("div.starter-template", [
                h("h1", "Learn More")
                h("p.lead", {align: "left"}, "In the United States, the frequency of medical diagnostics errors in outpatient settings is estimated to be more than 5%. In the cases of rare diseases, the outlook is much worse. All too often, patients are told that their physical illness is psychological and are brushed aside, left to fend for themselves. Patients need to take action to help themselves and others.")
                h("p.lead", {align: "left"}, "One of the most important ways patients can help themselves and each other is to collect and share medical data. In an ideal world, everyone would have access to a doctor that would not make diagnostic errors. However, the reality is that many people don't have access to or can't find an appropriate doctor in a reasonable time frame. This is especially problematic for chronic illnesses that progress over time. The first step to empowerment is for the patient to own all their medical records. This serves a few important purposes. First, it allows the patient to double check results and make sure there is no oversight by the doctor. Additionally, it allows the patient to take a complete record with them to new providers. Often, doctors will fax fragments with information lost in the process and possibly conflicting with the patient's assessment of the situation. By controlling the information given to the provider, the patient can better represent themselves and shape the discussion.")
                h("p.lead", {align: "left"}, "In order for patients to help each other, access to structured medical data is needed. By sharing such information, researchers can applying techniques such as machine learning algorithms to help make a diagnosis for difficult cases. Such data is currently very limited. While there are websites such as PatientsLikeMe that allows users to share data, the data itself is not freely available to researchers. The government also collects data, but approval through an accepted study must be given. P2pdx allows anyone to access the data without any approval, it is public domain. This will allow both hobbyists and professionals alike the opportunity to help improve diagnostics.")
            ])
        ])

    update: =>
        @need_update = true
        Page.projector.scheduleRender()

window.ContentLearnMore = ContentLearnMore
