---
page: :docsImages
name: Images
title: Images
metainformation: 'Images are a powerful way of explaining concepts, attracting a readers attention and creating an impact. Contentful has a separate Images API that helps you add and retrieve image files in spaces, but also offers manipulation features to make images look how you want.'
slug: null
tags:
  - Basics
  - Content model
nextsteps:
  - text: Images API reference
    link: /developers/docs/references/images-api/
---

Images are a powerful way of explaining concepts, attracting a readers attention and creating an impact. Contentful has a separate [Images API](/developers/docs/references/images-api/) that helps you add and retrieve image files in spaces, but also offers manipulation features to make images look how you want.

To best understand how to manipulate images we recommend you create a space filled with content from the 'Photo Gallery' example space.

![Create Space dialog](https://images.contentful.com/tz3n7fnw4ujc/5NvRrRmt9uW8aOUWIKSYui/c4172d774e25fc8a9608bc97c9fc6d5e/354BFE0A-179E-4B65-BFEA-91BA174E4269.png_dl_1)

If you switch to the _Media_ tab you will see the images in the space, note that most of them are large, requesting and loading each of these into your app will be a significant network and memory hit, ideally you want to request images at the size you need them.

Typically you retrieve images from [the context of one or more entries](/developers/docs/references/content-delivery-api/#/reference/links), or by [assets directly](/developers/docs/references/content-delivery-api/#/reference/assets). To make it clearer we will use a small JavaScript application to show Contentful's image features and how image assets relate to content entries.

![The Image content type selected and the entries it contains](https://images.contentful.com/tz3n7fnw4ujc/6ylJFXN3lSMeYiCIOqoIyK/272fc1628bb5e4959d22352d7a2a71b4/E8084960-8F4B-47CB-AA90-29D49A655DFD.png_dl_1)

## Retrieve assets and image url

Read [how to setup and authenticate a JavaScript app](/developers/docs/javascript/tutorials/using-js-cda-sdk/), and then fetch the assets from the space, constructing an URL for the image file.

~~~javascript
client.getAssets()
  .then(function (assets) {
    assets.items.map(function(asset){
      var imageURL = 'https:' + asset.fields.file.url;
    });
  })
  .catch(function (e) {
    console.log(e);
  });
~~~

Create a skeleton _index.html_ file to display the images. The example below uses [browserify (webpack is also usable) to package the SDK](/developers/docs/javascript/tutorials/using-js-cda-sdk/#in-a-browser) for use in a browser.

{: .note}
**Note**: This step would be unnecessary if you are using the SDK directly outside of a browser.

~~~html
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="bundle.js"></script>
    <meta charset="UTF-8">
    <title>Images Example</title>
</head>
<body>
<div id="images">

</div>
</body>
</html>
~~~

## Populate page with images

Inside the `forEach` loop, create an `image` element for each asset, `div` elements to contain them, and populate the `images` `div` with them.

~~~javascript
...
var imagesDiv = document.getElementById('images');

assets.items.forEach(function (asset) {
  var imageURL = 'https:' + asset.fields.file.url;
  var imageDiv = document.createElement("div");
  var imageFile = document.createElement("img");
  imageFile.src = imageURL;
  imageDiv.appendChild(imageFile);
  imagesDiv.appendChild(imageDiv);
});
...
~~~

This results in a page of large images, in terms of dimensions and file size.

![Browser with large images showing](https://images.contentful.com/tz3n7fnw4ujc/Et4A7sGSsgOW00k84IgGg/110db601f41b0d564829fb590f34deb6/4AD6920B-8243-4A2B-B200-10F6CE338328.png_dl_1)

Now you have the structure ready, it's time to experiment with Contentful's manipulation features.

## Resizing images

You can resize images by adding a parameter to the image url that sets a width, but will also maintain aspect ratio.

~~~javascript
...
assets.items.forEach(function (asset) {
  ...
  var imageURL = 'https:' + asset.fields.file.url + '?w=200';
  ...
});
...
~~~

![A browser with images resized by Contentful's Images API](https://images.contentful.com/tz3n7fnw4ujc/1oErqsRy44USwg886aOs60/8687ab5b2d2fc21675b4782247e5e427/BB35A865-8CE0-4DEC-86AA-2130CB001C03.png_dl_1)

Setting both the width and height of an image will still maintain the aspect ratio, so the code below will generate the same output as the previous example and possibly not the exact size you expect.

~~~javascript
...
assets.items.forEach(function (asset) {
  ...
  var imageURL = 'https:' + asset.fields.file.url + '?w=200&h=200';
  ...
});
...
~~~

If you want to override this behavior, you can use the `fit` parameter to control what part of the image Contentful returns.

This example creates a thumbnail of the image from the top left corner of the image.

~~~javascript
...
assets.items.forEach(function (asset) {
  ...
  var imageURL = 'https:' + asset.fields.file.url + '?fit=thumb&f=top_left&h=200&w=200';
  ...
});
...
~~~

![Images cropped to the top left corner](https://images.contentful.com/tz3n7fnw4ujc/4lZOBjlfSUCew4iKESKUWg/719aa6e1fdfc82cab02f5f2fd69dabb7/E5451651-380D-4C70-8B8F-CD5300AF620D.png_dl_1)

The `fit` parameter can take other values to change this behavior and suit your use case, [read more about what's possible in the Images API guide](/developers/docs/references/images-api/#/reference/resizing-&-cropping).

When you crop or resize an image you can round the corners with the `r` parameter. If you want to generate rounded images without resorting to CSS, set the value to `180`.

~~~javascript
...
assets.items.forEach(function (asset) {
  ...
  var imageURL = 'https:' + asset.fields.file.url + '?fit=thumb&f=top_left&h=200&w=200&r=180';
  ...
});
...
~~~

![An example of images rendered as circles](https://images.contentful.com/tz3n7fnw4ujc/IYjocRckSIWAuuqs6eKkO/255e197cd0a97d7df6917321ebce4b1a/21EF3CC9-3783-490B-B3F0-2C33E0A7CC4F.png_dl_1){: .animated}

## Adding your own images

You can add images to your spaces using the web app, which provides a comprehensive variety of methods for uploading files.

![The Contentful Image uploader form](https://images.contentful.com/tz3n7fnw4ujc/4aiM6qazlK6eKYcUESUeQO/80bbf85d469549cd369b7c014340f0ea/5AAF25BB-64F1-4274-BDB4-C76734C270AA.png_dl_1)

Adding images via the content management API involves three separate API calls, which all SDKs expose:

- **Creating an asset**, which is an entry for the media file.
- **Processing an asset**, Contentful downloads the media file from the URL supplied and processes it.
- **Publishing an asset**, making the entry and media file publicly available.

### Creating an asset

Authenticate and create a Contentful client, [this time using the management SDK as you want to create content](https://github.com/contentful/contentful-management.js).

Get the space you want to add an asset to.

~~~javascript
client.getSpace('idpvf88znfe3')
  .then(function (space) {
    ...
  });
~~~

Inside the `.then` method create the data object that contains information about the image you want to upload to Contentful, including the title for the asset, and data about the image file itself.

~~~javascript
var fileData = {
  fields: {
      title: {
          'en-US': 'Berlin'
      },
      file: {
          'en-US': {
              contentType: 'image/jpeg',
              fileName: 'berlin_english.jpg',
              upload: 'https://upload.wikimedia.org/wikipedia/commons/3/3b/Siegessaeule_Aussicht_10-13_img4_Tiergarten.jpg'
          }
      }
  }
};
~~~

Create the asset in the space:

~~~javascript
space.createAsset(fileData)
  .then(function (asset) {
    ...
  })
~~~

This will create an asset ready to process and publish inside the `.then` method:

~~~javascript
...
asset.processForAllLocales()
    .then(function (processedAsset) {
        processedAsset.publish()
            .then(function (publishedAsset) {
                console.log(publishedAsset);
            })
    })
    ...
~~~

Open up the space and you will see the new image inside.

![The Asset uploaded available in the space](https://images.contentful.com/tz3n7fnw4ujc/5WQd6ttXzyKKIig44kqUu4/1facf73658fe4bbe145d79394244e991/E6E90F1A-0D5E-4049-B7C6-67D8C3116E16.png_dl_1)

If you load the images page you made earlier again you will also now the see the new image listed alongside the existing images.
