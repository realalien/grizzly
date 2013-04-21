Grizzly
===================

### About
Grizzly is a simple API wrapper around the Weibo API V2. The name comes form the awesome Koala gem for facebook.

### Installation
Grizzly as a name was already taken on ruby gems. Awww. However grizzly-weibo was not. To install using bundler
add the following to your gem file.

```ruby
gem "grizzly-weibo", :require => "grizzly"
```

### Usage
To start using grizzly you want to create a client object. This client object allows you to interact with weibo api.
This can be done creating a new object of type ```Grizzly::Client```. You will need an access token 
to do this. Currently grizzly does not support authentication with oauth. If you need to do this then I recommend
using omniauth. There is already a working strategy for Weibo.

```ruby 
client = Grizzly::Client.new(access_token)
```

### Getting User Information
Once a client object has been created we can use it to download information based on a user id. Just call the user
method and pass it a single parameter. This is the uid of the user on Weibo. This method will return a user object
with all of the user data.
```ruby
user = client.user(11223344556677)
user.name             #=> "fredchang"
user.gender           #=> "m"
user.followers_count  #=> 53

```

### Updating Status
First things first. Lets update the users status. This only works after a user has been logged in and has an access token.

```ruby
client = Grizzly::Client.new(access_token)
status = client.status_update("Dude. Weibo is awesome!")
```

### Status Comments
Weibo supports adding comments to status updates. All comments for a status can be fetched in the following way. 
Note that we pass the id of the status that we are intrested in
```ruby 
comments = client.comments(status.id)
```

Note that all method calls made with Grizzly will always return a domain object. More often than not this domain object
is a representation of what ever JSON object has been returned by Weibo's API. In this case we get all sorts of handy
information on the status we just updated including the user that the status belongs to. So you can do...

```ruby
status.user.id    #=> "1233344545356356"
status.text       #=> "Dude. Weibo is awesome!"
```


### Friends
You can access a list of friends by supplying a weibo user id

```ruby
friends = client.friends(user_id)
```

This method will return an array of user friend objects. Data of these objects can be accessed via methods

```ruby
friends.first.id            #=> "1233344545356356"
friends.first.screen_name   #=> "Fred Chang"
friends.first.gender        #=> "m"
```

You can convert a user object to a hash if you need to however use . syntax where you can. Makes the code look cleaner

```ruby
friends.first.to_h["screen_name"] #=> "Fred Chang"
```

### Friends (Bilateral) 
Returns a list of your bilateral friends on Weibo. This list has users who are a fan of you and your are a fan of.

```ruby
friends = client.bilateral_friends(user_id)
```

This method returns the same friend object that ```client.friends``` returns.

### Cursors
Weibo API supports paging. Both the ```friends``` and ```bilateral_friends``` are paginated. This means that when we
call these methods we have a cursor object returned. This cursor object can be iterated over. Iterating in this way will
only iterate over the first 50 results

```ruby
friends = client.friends(user_id)
friends.each do |friend|
  ...
end
```

For something a little more robust we can iterate over pages as well. This will get all of a users friends iterating
over them in blocks of fifties. Note that each time you access friends.each an new request to the weibo api will be
generated.

```ruby
friends = client.friends(user_id)
while friends.next_page? #Loops untill end of collection
  friends.each do |friend|
    ... # Loops 50 times
  end
end
```

### Error Handling
Grizzly has its own set of errors that it can throw. ```Grizzly::Errors::NoAccessToken``` is thrown when the client is created with out an access token. ```Grizzly::Errors::WeiboAPI``` is thrown when ever there is an error returned by an end point of the API. This will return both a message and a weibo error code. ```Grizzly::Errors::Timeout``` will be thrown when the Weibo API is taking too long to respond to a response. There currently is a five second limit on the request time of each request made by Grizzly. Note that when your using a cursor class described above this time out applies to each request the cursor makes not the total time that the cursor takes to build the results of a given GET from the api.

### Development
Please feed free to fork, develop and send pull requests. If you plan to do this then you will need a valid weibo access token. Place this token in an access_token.yml file that can be found under the spec folder. Currently this file is in the git ignore list however you can copy the same file. Once you have done this add your access token to the file and specs will pick it up.

### Pull Requests
The changes are that what you want to do with the API is not supported. Let me know if that is the case and I will add support for anything you need to do. I will also accept any pull requests with new features included. I did not intend to release this gem full supported with each end point mapped.

### Contributors
 * realalien (Zhu Jia Cheng)

### License
Copyright (c) 2012 Stewart Matheson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
