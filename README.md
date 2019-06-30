# Coding-Challenge

I have made a comic app which i think stimulates(and beyond) a MVP for the customer's needs.

I know this app is supposed to be a MVP with some features, but i wanted to make as much as i could in 3 days.

What i would've made for the MVP would have been:
- Browse through the comics 
- See comic details and its description 
- Search for comics by the comic number as well as test.
This is because the customer wanted a comic VIEWER app, and to just see the comics, you dont necessarily need more features to do that.
I think the other features the customer wanted is want-to-have features.

Features i managed to create within deadline:
- Browse through the comics
- See the comic details, including its description. (image is zoomable)
- Search for comics by the comic number as well as text
- Get the comic explanation
- favorite the comics, which would be available offline too
- Send comics to others
- Support multiple form factors

To build this project i have used MVC pattern and followed SPA and tried to make the code as reusable as possible.

I have thought of egde cases, and quality cases. 
For example i have used a tabbar controller to show ComicBrowsing page, Favorite page and Searchpage. These pages is navigating to ComicDetail page. ComicDetail page is where you can add favorites (among other things), so i have added a notification system to update every active instance of that class when a user adds or deletes a favorite comic.
Every object which is loaded is also cached, to load as little as possbile and each cell is loading asynchronously to make the scrolling "smooth".

I have hade functions which now might just contain 1 line of code, but i've done this to make the code more readable. 
With this, it's easy to modify and add more code to it in the future.

I've tried to design each class to just know what it needs to know, which makes better structure.

I have focused on organizing my code-files. I have made folders to be first general and when you navigate into them, it gets more and more specific.


I have not done a lot of testing before, but i have added some.
