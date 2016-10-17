# psr15-middlewares

Collection of [PSR-15](https://github.com/http-interop/http-middleware) middlewares

This is a migration of most [psr7-middlewares](https://github.com/oscarotero/psr7-middlewares) to follow PSR-15 specification (currently released as `0.2.0` of `php-interop/http-middleware`).

## Requirements

* PHP >= 5.6
* A [PSR-7](https://packagist.org/providers/psr/http-message-implementation) http mesage implementation ([Diactoros](https://github.com/zendframework/zend-diactoros), [Guzzle](https://github.com/guzzle/psr7), [Slim](https://github.com/slimphp/Slim), etc...)
* A [PSR-15](https://github.com/http-interop/http-middleware) middleware dispatcher ([Middleman](https://github.com/mindplay-dk/middleman), etc...)

## Main differences with [psr7-middlewares](https://github.com/oscarotero/psr7-middlewares):

### PSR-15 compliant

`PSR-15` defines a set of interfaces for interoperability with `PSR-7` middleware adding the following changes:

* The double-pass signature `function ($request, $response, $next)` is replaced by the new lambda-style: `function ($request, $next)`.
* There are two different interfaces: `MiddlewareInterface` and `ServerMiddlewareInterface` in order to differentiate between middlewares requiring a `RequestInterface` or a `ServerRequestInterface`.

### Splitted the middlewares into separate packages

This is something [requested by some people](https://github.com/oscarotero/psr7-middlewares/issues/23) so with the PSR-15 comming up, this is a good opportunity to port these components in individual packages.

### Removed the vendor namespace from the request attribute

In the old psr7 version, some components insert automatically values in the request attributes in a way that is hard to recover. For example, in [ClientIp](https://github.com/oscarotero/psr7-middlewares#clientip) to get the user ip you need to use a static function:

```php
use PsrMiddlewares\Middleware\ClientIp;

$ip = ClientIp::getIp($request);
```

Because the "hard" way is:

```php
$data = $request->getAttribute('Psr7Middlewares\\Middleware');
$ip = isset($data['CLIENT_IPS'][0]) ? $data['CLIENT_IPS'][0] : null;
```

This was done to avoid conflicts with other attributes, but for convenience I decided to remove this method and use **configurable** attribute names:

```php
$ip = $request->getAttribute('client-ip'); //easy!!
```

Because the attribute name is configurable, you can use whatever you want in order to prevent conflict, for example, using a underscore as prefix:

```php
$dispatcher[] = (new Middlewares\ClientIp)->attribute('_client-ip');
```

### Splitted some components into separate subcomponents

In the psr7 old version, some components uses "resolvers" to do different things deppending of some circunstances (content-type, encoding, etc). [Payload](https://github.com/oscarotero/psr7-middlewares#payload) is an example of this: it can parse json, urlencoded or csv in the same class. Now this components have been splitted into subcomponents, so now there's a `JsonPayload`, `UrlEncodedPayload` and `CsvPayload`. Easier to maintain and extend.

### More open

The middlewares has been moved to this organization. This is not the oscarotero's middlewares, this is simply "middlewares" and the community is welcome to participate. 

## Usage example

```php
use Zend\Diactoros\ServerRequestFactory;
use mindplay\middleman\Dispatcher;
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
    new Middlewares\UrlEncodedPayload(),

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

    //Create and save a session in '_session' attribute
    (new Middlewares\AuraSession())
    	->attribute('_session'),

    //Add the php debugbar
    new Middlewares\Debugbar(),

    //Handle the routes with fast-route
    new Middlewares\FastRoute($app->get('dispatcher')),
]);

$response = $dispatcher->dispatch(ServerRequestFactory::fromGlobals());
```

## List of all available components

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
* [TrailingSlash](https://github.com/middlewares/trailing-slash)
* [Www](https://github.com/middlewares/www)

### Others

* [Filesystem](https://github.com/middlewares/filesystem)
  * [Reader](https://github.com/middlewares/filesystem#reader)
  * [Writer](https://github.com/middlewares/filesystem#writer)
* [ImageManipulation](https://github.com/middlewares/image-manipulation)
* [MethodOverride](https://github.com/middlewares/method-override)
* [Payload](https://github.com/middlewares/payload)
  * [CsvPayload](https://github.com/middlewares/payload#csvpayload)
  * [JsonPayload](https://github.com/middlewares/payload#jsonpayload)
  * [UrlEncodedPayload](https://github.com/middlewares/payload#urlencodepayload)


## Contributing

Use the package repository of each component to notify any issue or pull request related with it, and use this repository for generical questions, new middlewares discussions, etc.

If you want to contribute with new middlewares, you can take a look to [these ideas](https://github.com/middlewares/psr15-middlewares/projects/1) and create an issue to expose the functionality. There's also a [boilerplate](https://github.com/middlewares/boilerplate) that you can use for quick start.

See [CONTRIBUTING](CONTRIBUTING.md) for contributing details.

---

The MIT License (MIT). Please see [LICENSE](LICENSE) for more information.
