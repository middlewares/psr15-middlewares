# psr15-middlewares

Collection of [PSR-15](https://github.com/http-interop/http-middleware) middlewares

This is a migration of most [psr7-middlewares](https://github.com/oscarotero/psr7-middlewares) to follow PSR-15 specification (currently released as `0.2.0` of `php-interop/http-middleware`).

## Requirements

* PHP >= 5.6
* A [PSR-7](https://packagist.org/providers/psr/http-message-implementation) http mesage implementation ([Diactoros](https://github.com/zendframework/zend-diactoros), [Guzzle](https://github.com/guzzle/psr7), [Slim](https://github.com/slimphp/Slim), etc...)
* A [PSR-15](https://github.com/http-interop/http-middleware) middleware dispatcher ([Middleman](https://github.com/mindplay-dk/middleman), etc...)

## Main differences with [psr7-middlewares](https://github.com/oscarotero/psr7-middlewares)

### PSR-15 / PSR-17 compliant

`PSR-15` defines a set of interfaces for interoperability with `PSR-7` middleware adding the following changes:

* The double-pass signature `function ($request, $response, $next)` is replaced by the new lambda-style: `function ($request, $next)`.
* There's two different interfaces: `MiddlewareInterface` and `ServerMiddlewareInterface` in order to differentiate between middlewares requiring a `RequestInterface` or a `ServerRequestInterface`.

### Split the middlewares into separate packages

This is something [requested by many people](https://github.com/oscarotero/psr7-middlewares/issues/23) so with the PSR-15 comming up, this is a good opportunity to port these components in individual packages.

### Removed the vendor namespace from the request attribute

In the old version, some components insert automatically values in the request attributes in a way that is hard to recover. For example, in [ClientIp](https://github.com/oscarotero/psr7-middlewares#clientip) to get the user ip you need to use a static function:

```php
use PsrMiddlewares\Middleware\ClientIp;

$ip = ClientIp::getIp($request);
```

Because the "hard" way is:

```php
$data = $request->getAttribute('Psr7Middlewares\\Middleware');
$ip = isset($data['CLIENT_IPS'][0]) ? $data['CLIENT_IPS'][0] : null;
```

I decided to remove this and use **configurable** attribute names:

```php
$ip = $request->getAttribute('client-ip'); //easy!!
```

### Split middleware components in multiple subcomponents

In the old version, some components uses "transformer resolvers" to do different things deppending of some circunstances (content-type, encoding, etc). [Payload](https://github.com/oscarotero/psr7-middlewares#payload) is an example of this: it can parse json, urlencoded or csv in the same class. Now this components have been splitted into subcomponents, so now there's a `JsonPayload`, `UrlEncodedPayload` and `CsvPayload`. Easier to maintain and to extends.

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

    //Minify the html
    new Middlewares\HtmlMinifier(),

    //Override the method using X-Http-Method-Override header
    new Middlewares\MethodOverride(),

    //Parse the json payload
    new Middlewares\JsonPayload(),

    //Parse the urlencoded payload
    new Middlewares\UrlEncodedPayload(),

    //Saves the client ip in the 'ip' attribute
    (new Middlewares\ClientIp())
    	->attribute('ip'),

    //Allow only some ips
    new Middlewares\Firewall(['127.0.0.*']),

    //Add cache expiration
    new Middlewares\Expires(),

    //Negotiate the content-type
    new Middlewares\ContentType(),

    //Negotiate the language
    new Middlewares\ContentLanguage(['gl', 'es', 'en']),

    //Create and save a session in 'session' attribute
    (new Middlewares\AuraSession())
    	->attribute('session'),

    //Adds the php debugbar
    new Middlewares\Debugbar(),

    //Handle the routes with fast-route
    new Middlewares\FastRoute($app->get('dispatcher'))
]);

$response = $dispatcher->dispatch(ServerRequestFactory::fromGlobals());
```

## List of all available components

* [AccessLog](https://github.com/middlewares/access-log)
* [AuraRouter](https://github.com/middlewares/aura-router)
* [AuraSession](https://github.com/middlewares/aura-session)
* [BasePath](https://github.com/middlewares/base-path)
* [Cache](https://github.com/middlewares/cache)
  * [Cache](https://github.com/middlewares/cache#cache)
  * [CachePrevention](https://github.com/middlewares/cache#cacheprevention)
  * [Expires](https://github.com/middlewares/cache#expires)
* [ClientIp](https://github.com/middlewares/client-ip)
* [Cors](https://github.com/middlewares/cors)
* [Csp](https://github.com/middlewares/csp)
* [Debugbar](https://github.com/middlewares/debugbar)
* [ErrorHandler](https://github.com/middlewares/error-handler)
* [FastRoute](https://github.com/middlewares/fast-route)
* [Filesystem](https://github.com/middlewares/filesystem)
  * [Reader](https://github.com/middlewares/filesystem#reader)
  * [Writer](https://github.com/middlewares/filesystem#writer)
* [Firewall](https://github.com/middlewares/firewall)
* [Geolocation](https://github.com/middlewares/geolocation)
* [Honeypot](https://github.com/middlewares/honeypot)
* [ImageManipulation](https://github.com/middlewares/image-manipulation)
* [HttpAuthentication](https://github.com/middlewares/http-authentication)
  * [BasicAuthentication](https://github.com/middlewares/http-authentication#basicauthentication)
  * [DigestAuthentication](https://github.com/middlewares/http-authentication#digestauthentication)
* [Https](https://github.com/middlewares/https)
* [MethodOverride](https://github.com/middlewares/method-override)
* [Minifier](https://github.com/middlewares/minifier)
  * [CssMinifier](https://github.com/middlewares/minifier#cssminifier)
  * [HtmlMinifier](https://github.com/middlewares/minifier#htmlminifier)
  * [JsMinifier](https://github.com/middlewares/minifier#jsminifier)
* [Negotiation](https://github.com/middlewares/negotiation)
  * [ContentType](https://github.com/middlewares/negotiation#contenttype)
  * [ContentLanguage](https://github.com/middlewares/negotiation#contentlanguage)
  * [ContentEncoding](https://github.com/middlewares/negotiation#contentencoding)
* [Payload](https://github.com/middlewares/payload)
  * [CsvPayload](https://github.com/middlewares/payload#csvpayload)
  * [JsonPayload](https://github.com/middlewares/payload#jsonpayload)
  * [UrlEncodedPayload](https://github.com/middlewares/payload#urlencodepayload)
* [PhpSession](https://github.com/middlewares/php-session)
* [Recaptcha](https://github.com/middlewares/recaptcha)
* [ResponseTime](https://github.com/middlewares/response-time)
* [Robots](https://github.com/middlewares/robots)
* [Shutdown](https://github.com/middlewares/shutdown)
* [TrailingSlash](https://github.com/middlewares/trailing-slash)
* [Uuid](https://github.com/middlewares/uuid)
* [Whoops](https://github.com/middlewares/whoops)
* [Www](https://github.com/middlewares/www)


## Contributing

Use the package repository of each component to notify any issue or pull request related with it, and use this repositorio for generical questions, new middlewares discussions, etc.

See [CONTRIBUTING](CONTRIBUTING.md) for contributing details.

---

The MIT License (MIT). Please see [LICENSE](LICENSE) for more information.
