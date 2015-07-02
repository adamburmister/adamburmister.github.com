---
title: angularjs-data-syncronisation
date: 2013-08-29 13:11 +01:00
tags:
published: false
---

Multi-browser/tab data sync - Where SPAs fail currently, and can MeteorJS and AngularJS play together ftw?

I've been working with AngularJS for about 6 months on a sizable production app, so have a good basis of experience now.

In that time it's become apparent that there's currently a disconnect between Single Page Apps and the server technology we're currently using.
In our case we're using a Restful Rails CORS JSON API - however this problem will exist with all RESTful servers.

I've talked to a few CTOs working on similar scale apps and they're all struggling with the same issue.

I wanted to take a bit of time to, A) feed back my thoughts on this with the group, B) get your feedback and thoughts on a possible solution.

An introduction to the problem:

We've moved the source of truth off the server, into our smart clients. This swing of the pendulum means we're now back to dealing with data syncronisation issues. If the client is now the source of truth, how do we distribute that truth to our central server, and how do we further distribute it to our other simultaneous users.

For public-facing-only apps this is a bit easier, as a simple broadcast over websockets (or similar) can deal with this.

The difficulty comes particularly when you're dealing with authenticated users, working on access-protected data.

An example of this problem:

My startup, Seneca.io, is a board reporting SaaS product. Some users love opening multiple tabs, one for each of their previous board reports, presumably so they can switch between them quicker.

Now I have, for example, 4 tabs open: 4 different running versions of the app, each with their own JSON model being monitored by AngularJS, each their own sources-of-truth.

Our JSON object is quite deep - a User has many Companies which have many Meetings. 
When a the user changes the date on a Meeting we send a RESTful PUT request back to an endpoint (i.e. api.seneca.io/1/company/id/meeting/id). The server now has the latest changes, but our 3 other tabs are now out of date.

This is the crux of the problem. How do you update the other 3 running instances? The nieve example is to send a WebSocket message saying the current company/meeting is now out of date.
For this to work we'll have to be given information on how to traverse into our JSON object 

What's a good architectural solution?

Is a MeteorJS-like DPP a viable solution with AngularJS?

http://www.meteor.com/blog/2012/03/21/introducing-ddp
