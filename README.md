Book App.

This is an App which should helo reaching your REad Goal by telling you how many page of a book you have to Read every Day to finish your book List this Year.
One can add booky to ones library by using the ISBN Number.

Current Functions:
- Add Books (local Databse (sqflite))
- Display Daily Reads
- Reoderder your Reading List

Current Flaws:
- not tested for many edge cases
- not everything fail proof like try catch
- Daily Reads doesnt update in Realt Time due to a Problem of the Architecure of the App. I need to find a way to change without reloading 
  the whole page. Probably by using an extra BLOC
  
ToDO:
- Nicer Screen for Searching Books
- Show Errors when entering wrong ISBN

Later Change evetnually:
- When you add a new book to your reading List todays pages to Read wont chang. Not Sure if I want to Kepp it that way
