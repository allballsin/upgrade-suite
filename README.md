# Upgrade Suite


### History
One day late in the nineties, I quit my day job and spent six months creating software that would revolutionise the transmission, updating and repair of sets of files of any type over low-speed networks. I would become rich in the process. 

Cue to today...

I found the software deep in an old repository and thought I'd bring it back to life. 

The nature of most commercial software development at the time involved using proprietary tools and languages on a single platform. Even the manual required Microsoft Word to view it properly. So the first challenge was getting the code base to compile again. 

Borland Delphi was my development tool of choice in 1998, with a smattering of third party components and libraries.

Fortunately without too much messing around this installed on Windows 10. There were problems with components of the installation that I didn't need so I left them out.

### Compile It Yourself
See the file COMPILETHEOLD.md for instructions on compiling the original software using Delphi 5 on Windows 10. It may work on other versions of Delphi and Windows. YMMV.

Note though, that I have included the original installation files for the full retail version so you can try to install it yourself on whatever your flavour of OS that might run old Windows software.

There is a Client and Server installation file, explained in the manual (provided in PDF and the original Doc format).

One awesome aspect of Delphi at the time is that it could compile nearly all of your dependencies into a single exe. This makes executing it on different Windows setups likely.

The Windows exes (the old releases and newly compiled exes) have not been thoroughly tested since 2001. You have been warned :)


### Important Security Information
From the Security section of the manual (starts page 78):

*"If you are going to use Upgrade Suite to transmit sensitive corporate or personal information, make sure you have encrypted it using a recognized encryption tool before preparing it for deployment. Network security vigilance is your responsibility."*



### Bringing It Back To Life
If I want to update and release this on different or newer platforms without spending more money, I can’t. 

If I don’t want to develop on Windows without messing around a lot or spending more money, I can’t. 

If I want other people to be able to work on the code, they can’t easily do it.

So porting it in some way is the way to go.

### Why Not Transpile?
This seems like a potential future opportunity to make a transpiler from Delphi (Object Pascal) to a language that does not have a proprietary IDE or 3rd party packages. Delphi was great for me at the time, but that time is over.

An interesting question is whether a transpiled source file maintains the original file’s copyright where I have used 3rd party code.

I wrote a very detailed manual which will serve as a certification document that the transpiled software works as it should.

The only other consideration is that I need to transpile both Object Pascal and some inline assembly.

Note that I have left the object files (.dcu, .obj, etc.) intact because as is, this source tree  compiled/linked for me without much hassle and it may do so for you if you are curious. As stated, the goal of this exploration is not to get exes compiled by Delphi 5 from a clean set of source code :)

An early decision to be made is to select a target language for the transpilation based on:

- cost
- platform agnosticism
- ability to easily express Delphi's language paradigms and features as used in Upgrade Suite
- capable of performing Upgrade Suite's functionality
- be either well known, easy to pick up, or both
- able to support TDD (or close to it) because this is going to need a lot of testing!

Another decision is whether the transpiler needs to be written in the same language. 

The transpiler's language choice will be predicated on whether the focus of the sharing of this project is the ported software, the software that ports it, or both.

Enjoy!
