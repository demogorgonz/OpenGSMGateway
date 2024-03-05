# Rundeck

!!! info "It is important to select **Method** to be `GET`, while **Payload Format** doesn't matter." 

___

## Call

`http://FQDN:8080/call?number=XXXXXX`

![](files/RundeckCall.png) 

___

## SMS

`http://FQDN:8080/sms?number=XXXXXX&message=Text%20message%20with%20spaces`

![](files/RundeckSMS.png) 

!!! info "Since we can't manipulate Webhook arguments, this is required format to submit SMS message to API." 

{% include 'footer.md' %}
