# MyBrowseOverflow

[![Build Status](https://travis-ci.org/asalom/MyBrowseOverflow.svg)](https://travis-ci.org/asalom/MyBrowseOverflow)
[![Coverage Status](https://coveralls.io/repos/asalom/MyBrowseOverflow/badge.svg)](https://coveralls.io/r/asalom/MyBrowseOverflow)

> IMPORTANT: I am not affiliated with Test Driven iOS Development nor Graham Lee in any way.

My solution to the application developed at [Graham Lee](https://github.com/iamleeg)'s book [Test Driven iOS Development](http://www.amazon.com/Test-Driven-iOS-Development-Developers-Library/dp/0321774183).
Instead of manually creating mock, stub and fake objects I used [OCMock 3](http://ocmock.org/) framework with the *verify-after-running* approach.
At the time I reached out Graham's book, StackOverflow had already shutdown their v1 API so I will be using v2.2 instead with the appropiate changes in the code and the tests.

## JSON objects used for testing
### Question
[/2.2/questions/11047351?filter=withbody&site=stackoverflow](http://api.stackexchange.com/2.2/questions/11047351?filter=withbody&site=stackoverflow)
```json
{
    "items": [
    {
        "tags": [
            "objective-c",
            "properties",
            "protected"
        ],
        "owner":{
            "reputation": 647,
            "user_id": 1266056,
            "user_type": "registered",
            "accept_rate": 100,
            "profile_image": "https://www.gravatar.com/avatar/f6d542dbc5488619e1498aa6b11e1209",
            "display_name": "Alex Salom",
            "link": "http://stackoverflow.com/users/1266056/alex-salom"
        },
            "is_answered": true,
            "view_count": 7051,
            "accepted_answer_id": 11047650,
            "answer_count": 3,
            "score": 28,
            "last_activity_date": 1401541337,
            "creation_date": 1339749908,
            "last_edit_date": 1401541337,
            "question_id": 11047351,
            "link": "http://stackoverflow.com/questions/11047351/workaround-to-accomplish-protected-properties-in-objective-c",
            "title": "Workaround to accomplish protected properties in Objective-C",
            "body": "<p>I've been trying to find a workaround to declare @protected properties in Objective-C so only subclasses in the hierarchy can access them (read only, not write).</p>"
    }],
    "has_more": false,
    "quota_max": 10000,
    "quota_remaining": 9994
}
```