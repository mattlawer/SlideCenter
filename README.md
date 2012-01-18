SlideCenter
=======================

SlideCenter is a Notification Center Widget for iOS ≥ 5.0.

It will display the pictures you have in your library in the notification center.



Donations
---------

If you like this Widget, a Paypal donation would be very appreciated (mathieu.bolard [at] gmail [dot] com) 



How to use
----------

Clone this repo locally, then navigate into the SlideCenter directory (the root of the repo) in Terminal.

1. You need to make a symbolic link to your [theos](https://github.com/DHowett/theos) directory :  
	`ln -s YOUR_THEOS_DIR ./theos`
	exemple `ln -s /Users/mathieu/iOS/theos ./theos`
	
2. To build the .deb file juste type:  
	`./compil.sh`
	
3. To install the .deb file on your jailbroken iOS device:  
	*SSH the file to your iDevice and install it with iFile
	*SSH the file to your iDevice and install it with this command: `dpkg -i ./SlideCenter.deb`
	
4. To enable it go to the Settings app in notifications section and enable the Slide Center Widget to show in the Notification Center.
	


License and Warranty (Basically BSD)
-------------------------------------

License Agreement for Source Code provided by Mathieu Bolard [@mattlawer](http://twitter.com/mattlawer)

This software is supplied to you by Mathieu Bolard in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Mathieu Bolard grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Mathieu Bolard as the original author of the source code shall be included in all such resulting software products or distributions. 
Neither the name, trademarks, service marks or logos of Mathieu Bolard may be used to endorse or promote products derived from the software without specific prior written permission from Mathieu Bolard. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Mathieu Bolard herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.

The software is provided by Mathieu Bolard on an "AS IS" basis. MATHIEU BOLARD MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL MATHIEU BOLARD BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF MATHIEU BOLARD HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
