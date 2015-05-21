# MyBrowseOverflow

[![Build Status](https://travis-ci.org/asalom/MyBrowseOverflow.svg)](https://travis-ci.org/asalom/MyBrowseOverflow)
[![Coverage Status](https://coveralls.io/repos/asalom/MyBrowseOverflow/badge.svg)](https://coveralls.io/r/asalom/MyBrowseOverflow)

> IMPORTANT: I am not affiliated with Test Driven iOS Development nor Graham Lee in any way.

My solution to the application developed at [Graham Lee](https://github.com/iamleeg)'s book [Test Driven iOS Development](http://www.amazon.com/Test-Driven-iOS-Development-Developers-Library/dp/0321774183).
Instead of manually creating mock, stub and fake objects I used [OCMock 3](http://ocmock.org/) framework with the *verify-after-running* approach.
At the time I reached out Graham's book, StackOverflow had already shutdown their v1 API so I will be using v2.2 instead with the appropiate changes in the code and the tests.

## JSON objects used for testing
### Question
```json
{
    "items": [
    {
        "tags": [
            "ios",
            "iphone",
            "mobile",
            "itunesconnect"
        ],
        "owner":{
            "reputation": 3846,
            "user_id": 980344,
            "user_type": "registered",
            "accept_rate": 53,
            "profile_image": "https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209",
            "display_name": "Alex Salom",
            "link": "http://stackoverflow.com/users/980344/velthune"
        },
        "is_answered": false,
        "view_count": 11,
        "answer_count": 1,
        "score": 2,
        "last_activity_date": 1432119740,
        "creation_date": 1432119146,
        "last_edit_date": 1432119740,
        "question_id": 30347541,
        "link": "http://stackoverflow.com/questions/30347541/submit-test-version-on-itunesconnect",
        "title": "Submit test version on iTunesConnect",
        "body": "<p>Maybe is not the more appropriate place where ask this question and in this case I apologize.</p>"
    }],
    "has_more": true,
    "quota_max": 10000,
    "quota_remaining": 9994
}
```