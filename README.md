# Libratito

## Overview

Libratito provides a bridge service for tracking Tito registration events in Librato.

## Deployment

* `LIBRATO_USER`
* `LIBRATO_TOKEN`
* `TITO_WEBHOOK_SECRET`

### Local

```bash
$ bundle install
$ export LIBRATO_USER
$ export LIBRATO_TOKEN
$ export TITO_WEBHOOK_SECRET
$ foreman start
```

### Heroku

```bash
$ export DEPLOY=production/staging/you
$ heroku create -r $DEPLOY libratito-$DEPLOY
$ heroku config:set -r $DEPLOY LIBRATO_USER
$ heroku config:set -r $DEPLOY LIBRATO_TOKEN
$ heroku config:set -r $DEPLOY TITO_WEBHOOK_SECRET
$ git push $DEPLOY master
```

## License

Libratito is distributed under the MIT license.

