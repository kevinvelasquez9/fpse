## FPSE Final Project

## Overview

URL Shortener is a full-stack web app that allows users to create shortened URLs, follow users, and get a feed of the shortened urls of users they follow. When the user first runs the app, they are greeted with the sign in page. After successfully signing in, there is a home page with a submission form where the user enters a full url and their own shortened url and two lists, one for the user's url and one for their feed. After successfully verifying and creating the shortened url, the new shortened url is added to the url list. Pressing a shortened url will send the user to a redirect page, where they can press a button to send them to the full url. From the home page, you can search for users. When you click on a user, you can follow or unfollow the user.

## How to Run

After cloning the project, go to the client folder and run `npm install` to install any dependencies. Then go to the server folder and run `opam install .` to install dune dependencies. From the client folder of the project, run `npm run start`, which builds the rescript project. Again from the client folder, run `npm run serve`, which runs the vite server. Now from the server folder, run `dune exec ./src/app.exe`. Now the webpage can be viewed from `http://localhost:3000/`. In order to run the tests, from the server folder, run `dune exec ./src/test.exe`.

Team members:

- Kevin Velasquez (kvelasq1): Worked primarily on files in server folder
- Fernando Nova (fnova1): Worked primarily on files in client folder
