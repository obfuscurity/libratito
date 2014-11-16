# Libratito

## Overview

Libratito provides a bridge service for tracking Tito registration events in [Librato](https://www.librato.com/).

I love [Tito](https://ti.to/) but their data visualization has always left me wanting for more. Specifically, I want to be able to monitor long-term trends and financial performance over the course of an entire event, not just the last 30 days.

My hope is that the Tito engineers will continue to expose more data through their [Webhook](https://ti.to/docs/webhook) payload, which can then be easily captured by Libratito and forwarded to Librato.

## Metrics Reported

### Gauges

* `libratito.ticket.price`
* `libratito.ticket.type.<name>.created`
* `libratito.ticket.type.<name>.updated`

### Annotation Streams

* `ticket_created`
* `ticket_updated`

## Deployment

First, you will need to create a record-only Librato token. Set this information aside for later. You will also need a secret passphrase to be used by the Tito webhook to authenticate to Libratito. There are no class requirements on the passphrase, but use common sense here.

So far you should have the following:

* `LIBRATO_USER`
* `LIBRATO_TOKEN`
* `TITO_WEBHOOK_SECRET`

Next, create your Heroku app and push the local Librato fork/clone up to Heroku.

```bash
$ heroku create
$ heroku config:set LIBRATO_USER=...
$ heroku config:set LIBRATO_TOKEN=...
$ heroku config:set TITO_WEBHOOK_SECRET=...
$ git push heroku master
```

Now login to your Tito account and navigate to the "Customize &gt; Webhooks" section. You'll need to add the URL for your Libratito app into the `Ticket Create Webhook URL`. This can be retrieved using the following command:

```bash
$ heroku apps:info | grep Web | awk '{print $3}'
```

Finally, take the string you set for `TITO_WEBHOOK_SECRET` and enter it in the "Custom Data" field on the same page. Once this is complete you can press save and you should be done. Add an attendee to test that your webhook is working and metrics are being received. You can also use `heroku logs -t` to monitor the application logs.

## License

Libratito is distributed under the MIT license.

