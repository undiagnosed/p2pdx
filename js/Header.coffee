class Header extends Class
    constructor: ->

    handleSelectUserClick: ->
        Page.cmd "certSelect", {"accepted_domains": ["zeroid.bit"], "accept_any": true}
        return false

    render: =>

        @log "header"

        h("div.head", [
            h("nav.navbar.navbar-inverse.navbar-fixed-top", [
                h("div.container", [
                    h("div.navbar-header", [
                        h("button.navbar-toggle.collapsed", {'data-toggle': "collapse", 'data-target': "#navbar", 'aria-expanded': "false", 'aria-controls': "navbar"}, [
                            h("span.sr-only", "Toggle navigation")
                            h("span.icon-bar")
                            h("span.icon-bar")
                            h("span.icon-bar")
                        ])
                        h("a.navbar-brand.active", {href: "?Home", onclick: Page.handleLinkClick}, "p2pdx")
                    ])
                    if Page.site_info?.cert_user_id
                        @log "header cert user"
                        h("div.selected", [
                            h("div.collapse.navbar-collapse", {id: "navbar"}, [
                                h("ul.nav.navbar-nav", [
                                    h("li", [
                                        h("a", {href: "?Search", id: "search", onclick: Page.handleLinkClick}, "Search")
                                    ])
                                    h("li", [
                                        h("a", {href: "#Select+user", id: "login", onclick: @handleSelectUserClick}, Page.site_info.cert_user_id)
                                    ])
                                    h("li", [
                                        h("a", {href: "?Tests", id: "tests", onclick: Page.handleLinkClick}, "Tests")
                                    ])
                                    h("li", [
                                        h("a", {href: "?Vitals", id: "vitals", onclick: Page.handleLinkClick}, "Vitals")
                                    ])
                                    h("li", [
                                        h("a", {href: "?Symptoms", id: "symptoms", onclick: Page.handleLinkClick}, "Symptoms")
                                    ])
                                    h("li", [
                                        h("a", {href: "?Visits", id: "visits", onclick: Page.handleLinkClick}, "Visits")
                                    ])
                                    h("li", [
                                        h("a", {href: "?Diagnoses", id: "diagnoses", onclick: Page.handleLinkClick}, "Diagnoses")
                                    ])
                                    h("li", [
                                        h("a", {href: "?Medications", id: "medications", onclick: Page.handleLinkClick}, "Medications")
                                    ])
                                ])
                            ])
                        ])
                    else
                        @log "header no user"
                        h("div.unselected", [
                            h("div.collapse.navbar-collapse", {id: "navbar"}, [
                                h("ul.nav.navbar-nav", [
                                    h("li", [
                                        h("a", {href: "?Search", id: "search", onclick: Page.handleLinkClick}, "Search")
                                    ])
                                    h("li", [
                                        h("a", {href: "#Select+user", id: "login", onclick: @handleSelectUserClick}, "Login")
                                    ])
                                ])
                            ])  
                        ])
                    ])
                ]) 
            ])

window.Header = Header

