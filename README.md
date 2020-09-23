Book App.

This is an App which should help reaching your read Goal by telling you how many page of a book you have to read every Day to finish your Booklist this Year.
One can add books to the library by using the ISBN Number.

Current Functions:
- Add Books (local Databse (sqflite))
- Display Daily Reads
- Reoderder your Reading List

Current Flaws:
- not tested for many edge cases
- not everything fail proof like try catch
- Daily Reads doesnt update in Realt Time due to a Problem of the Architecure of the App. I need to find a way to change without reloading 
  the whole page. Probably by using an extra BLOC -> is fixed now
  
ToDO:
- Nicer Screen for Searching Books
- Show Errors when entering wrong ISBN

Here are a few Pictures:
![Screenshot_1600852506](https://user-images.githubusercontent.com/48860268/93997776-0d660b80-fd94-11ea-94ef-eb5fe230cd0a.png)
![Screenshot_1600852511](https://user-images.githubusercontent.com/48860268/93997810-1525b000-fd94-11ea-8f9c-f809914569dd.png)
![Screenshot_1600852455](https://user-images.githubusercontent.com/48860268/93997826-19ea6400-fd94-11ea-83e7-244d3e4457cd.png)
