// Function to swap links

          var linknumber = 4 ;

          var randomnumber = Math.random() ;

          var rand1 = Math.round( (linknumber-1) * randomnumber) + 1 ;

          links = new Array

		  links[1] = '<a href=\"news/index.html#2\">Report Available on Results of Library Service Quality Survey<\/a>'

		  links[2] = '<a href=\"news/index.html#3\">Library Launches \"Bruin Success with Less Stress\"<\/a>'

		  links[3] = '<a href=\"news/index.html#4\">UCLA Librarians Featured in Recruitment Video<\/a>'

		  links[4] = '<a href=\"news/index.html#5\">Exhibit on Seventeen-Year Cicadas<\/a>'

		  var link = links[rand1]

// End -->



// Function to swap images

          var imagenumber = 11 ;

          var randomnumber = Math.random() ;

          var rand1 = Math.round( (imagenumber-1) * randomnumber) + 1 ;

          images = new Array

          images[1] = "images/topleftpic_1.jpg"

          images[2] = "images/topleftpic_2.jpg"

          images[3] = "images/topleftpic_3.jpg"		  

          images[4] = "images/topleftpic_4.jpg"

          images[5] = "images/topleftpic_5.jpg"

          images[6] = "images/topleftpic_6.jpg"

          images[7] = "images/topleftpic_7.jpg"

          images[8] = "images/topleftpic_8.jpg"

          images[9] = "images/topleftpic_9.jpg"

          images[10] = "images/topleftpic_10.jpg"

          images[11] = "images/topleftpic_11.jpg"

          var image = images[rand1]

// End -->



// Function to popup help windows on home page



function popupHelp(name) {

_loc = 'help/' + name + '.html';

popupsWin = window.open(_loc,"PSpopups","toolbar=no,width=500,height=500,scrollbars=yes,resizable=no");

if (popupsWin.opener == null) { popupsWin.opener = self }

} 

// End -->



// Function close popup window on link click

function ChangeParentDocument(url) {

            opener.location = url;

			window.self.close();

          }

// End -->





// Function close popup window

function CloseWindow() {

			window.self.close();

          }

// End -->





// Function to reset menus



function setForm1() {

 document.SearchForm1.Online[0].selected = true;

}

function setForm2() {

 document.SearchForm2.Books[0].selected = true;

}

function setForm3() {

 document.SearchForm3.Journals[0].selected = true;

}

function setForm4() {

 document.SearchForm4.Articles[0].selected = true;

}

function setForm5() {

 document.SearchForm5.Research[0].selected = true;

}

function setForm6() {

 document.SearchForm6.Help[0].selected = true;

}



// End -->

