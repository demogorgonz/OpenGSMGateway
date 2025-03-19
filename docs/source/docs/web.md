# Web

!!! info "JS script on the page will set the action URL of the forms dynamically to the current browser URL."
!!! danger "It is *not safe* or *recommended* to expose this service to internet without SSL and secure form of authentication"

Visit http://IP:8080 or http://FQDN:8080

Following web forms will submit requests to [API](api.md) for scheduled processing.

## Web Template 

To change Template, locate and edit file `views/index.html` :

```html
        <option value="Template - Example 1">Template - Example 1</option>
        <option value="Template - Example 2">Template - Example 2</option>
        <option value="Template - Example 3">Template - Example 3</option>
        <option value="Template - Example 4">Template - Example 4</option>
        <option value="Template - Example 555555555555">Template - Example 555555555555</option>

```

![Web UI](files/web.png)
