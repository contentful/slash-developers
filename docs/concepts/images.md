---
page: :docsImages
---

# temp

Images are a powerful way of explaining concepts, attracting a readers attention and creating an impact. Contentful has a seperate Images API that not only helps you retrieve image files for your Spaces, but also offers manipulation features to make images look exactly how you want.

For this **tutorial** we will use a space filled with content from teh 'Photo Gallery' example space.

![Create Space](create-image-space.png)

If you switch to the _Media_ tab you will see the images contained within the space, note that most of them are quite large, requesting each of these and loading them into your app will be a significant network and memory hit, idealy you want to request images at the size you need them.

The images API (at _images.api.com_) is the only API that you don't need to authenticate with, so to retrieve a single image use the following call:

```
https://images.contentful.com/<space_id>/<token1>/<token2>/<name>
```
