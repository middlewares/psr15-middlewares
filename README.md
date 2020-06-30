![logo](art/logo.svg)

# psr15-middlewares

Collection of [PSR-15](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-15-request-handlers.md) middlewares

## Requirements

* PHP >= 7.0
* A [PSR-7](https://packagist.org/providers/psr/http-message-implementation) http message implementation ([Diactoros](https://github.com/laminas/laminas-diactoros), [Guzzle](https://github.com/guzzle/psr7), [Slim](https://github.com/slimphp/Slim), etc...)
* A [PSR-15 middleware dispatcher](https://github.com/middlewares/awesome-psr15-middlewares#dispatcher)

## Usage example

```php
use Zend\Diactoros\ServerRequestFactory;
use Middlewares\Utils\Dispatcher;
use Middlewares;

$dispatcher = new Dispatcher([

    //Handle errors
    (new Middlewares\ErrorHandler())
    	->catchExceptions(true),

    //Log the request
    new Middlewares\AccessLog($app->get('logger')),

    //Calculate the response time
    new Middlewares\ResponseTime(),

    //Removes the trailing slash
    new Middlewares\TrailingSlash(false),

    //Insert the UUID
    new Middlewares\Uuid(),

    //Disable the search engine robots
    new Middlewares\Robots(false),

    //Compress the response to gzip
    new Middlewares\GzipEncoder(),

    //Minify the html
    new Middlewares\HtmlMinifier(),

    //Override the method using X-Http-Method-Override header
    new Middlewares\MethodOverride(),

    //Parse the json payload
    new Middlewares\JsonPayload(),

    //Parse the urlencoded payload
    new Middlewares\UrlEncodePayload(),

    //Save the client ip in the '_ip' attribute
    (new Middlewares\ClientIp())
    	->attribute('_ip'),

    //Allow only some ips
    (new Middlewares\Firewall(['127.0.0.*']))
        ->ipAttribute('_ip'),

    //Add cache expiration headers
    new Middlewares\Expires(),

    //Negotiate the content-type
    new Middlewares\ContentType(),

    //Negotiate the language
    new Middlewares\ContentLanguage(['gl', 'es', 'en']),

    //Handle the routes with fast-route
    new Middlewares\FastRoute($app->get('dispatcher')),

    //Create and save a session in '_session' attribute
    (new Middlewares\AuraSession())
        ->attribute('_session'),

    //Add the php debugbar
    new Middlewares\Debugbar(),

    //Handle the route
    new Middlewares\RequestHandler(),
]);

$response = $dispatcher->dispatch(ServerRequestFactory::fromGlobals());
```

## List of all available middlewares

### Authentication

* [HttpAuthentication](https://github.com/middlewares/http-authentication)
  * [BasicAuthentication](https://github.com/middlewares/http-authentication#basicauthentication)
  * [DigestAuthentication](https://github.com/middlewares/http-authentication#digestauthentication)

### Client info

* [ClientIp](https://github.com/middlewares/client-ip)
* [Negotiation](https://github.com/middlewares/negotiation)
  * [ContentType](https://github.com/middlewares/negotiation#contenttype)
  * [ContentLanguage](https://github.com/middlewares/negotiation#contentlanguage)
  * [ContentEncoding](https://github.com/middlewares/negotiation#contentencoding)
* [Geolocation](https://github.com/middlewares/geolocation)

### Develop utils

* [AccessLog](https://github.com/middlewares/access-log)
* [Debugbar](https://github.com/middlewares/debugbar)
* [ErrorHandler](https://github.com/middlewares/error-handler)
* [ReportingLogger](https://github.com/middlewares/reporting-logger)
* [ResponseTime](https://github.com/middlewares/response-time)
* [Shutdown](https://github.com/middlewares/shutdown)
* [Uuid](https://github.com/middlewares/uuid)
* [Whoops](https://github.com/middlewares/whoops)

### Optimization

* [Cache](https://github.com/middlewares/cache)
  * [Cache](https://github.com/middlewares/cache#cache)
  * [CachePrevention](https://github.com/middlewares/cache#cacheprevention)
  * [Expires](https://github.com/middlewares/cache#expires)
* [Encoder](https://github.com/middlewares/encoder)
  * [DeflateEncoder](https://github.com/middlewares/encoder#deflateencoder)
  * [GzipEncoder](https://github.com/middlewares/encoder#gzipencoder)
* [Minifier](https://github.com/middlewares/minifier)
  * [CssMinifier](https://github.com/middlewares/minifier#cssminifier)
  * [HtmlMinifier](https://github.com/middlewares/minifier#htmlminifier)
  * [JsMinifier](https://github.com/middlewares/minifier#jsminifier)

### Routers

* [AuraRouter](https://github.com/middlewares/aura-router)
* [FastRoute](https://github.com/middlewares/fast-route)
* [RequestHandler](https://github.com/middlewares/request-handler)

### Security

* [Cors](https://github.com/middlewares/cors)
* [Csp](https://github.com/middlewares/csp)
* [Firewall](https://github.com/middlewares/firewall)
* [Honeypot](https://github.com/middlewares/honeypot)
* [Recaptcha](https://github.com/middlewares/recaptcha)
* [ReferrerSpam](https://github.com/middlewares/referrer-spam)
* [Robots](https://github.com/middlewares/robots)

### Session

* [AuraSession](https://github.com/middlewares/aura-session)
* [PhpSession](https://github.com/middlewares/php-session)

### Urls

* [BasePath](https://github.com/middlewares/base-path)
* [Https](https://github.com/middlewares/https)
* [Redirect](https://github.com/middlewares/redirect)
* [TrailingSlash](https://github.com/middlewares/trailing-slash)
* [Www](https://github.com/middlewares/www)

### Others

* [Proxy](https://github.com/middlewares/proxy)
* [Filesystem](https://github.com/middlewares/filesystem)
  * [Reader](https://github.com/middlewares/filesystem#reader)
  * [Writer](https://github.com/middlewares/filesystem#writer)
* [ImageManipulation](https://github.com/middlewares/image-manipulation)
* [ContentLength](https://github.com/middlewares/content-length)
* [MethodOverride](https://github.com/middlewares/method-override)
* [Payload](https://github.com/middlewares/payload)
  * [CsvPayload](https://github.com/middlewares/payload#csvpayload)
  * [JsonPayload](https://github.com/middlewares/payload#jsonpayload)
  * [UrlEncodePayload](https://github.com/middlewares/payload#urlencodepayload)


## Contributing

Use the package repository of each component to notify any issue or pull request related with it, and use this repository for generical questions, new middlewares discussions, etc.

If you want to contribute with new middlewares, you can take a look to [these ideas](https://github.com/middlewares/ideas). There's also a [skeleton](https://github.com/middlewares/skeleton) that you can use for quick start.

See [CONTRIBUTING](CONTRIBUTING.md) for contributing details.

## Logo

Download the logo from [the art directory](art).

---

The MIT License (MIT). Please see [LICENSE](LICENSE) for more information.
