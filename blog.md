---
layout: page
title: Blog(GSoC 2022)
---
<br>
Hello there!,<br>
This is my blog regarding my experience with the project idea of **Adding features to simpPRU** which I am doing under the [Google Summer Of Code 2022](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiorJS6uPj4AhWt1jgGHSoIBgUQjBB6BAgPEAE&url=https%3A%2F%2Fsummerofcode.withgoogle.com%2Fprograms%2F2022&usg=AOvVaw3w-bdu5PwRty8BzBPIquht).<br>

## Student Application period
The journey starts from the pre-gsoc period of undertanding of what was simpPRU,when Vedant Paranjape introduced me to his masterpiece about what it was,how it was generated ,what was the purpose of it.I was having a basic understanding of compiler at that time as I had some exposure of trying out the GCC.The project idea itself gave a good insight about the usefulness of simpPRU and the tools used to build it was of great importance in terms of parsing in compiler.<br>

The concept was quite interesting and had decided to give a shot to apply for the project of [Adding features to simpPRU](https://github.com/VedantParanjape/simpPRU) and started exploring its codebase.When I decided to go for this project,I read about the previous year projects in [BeagleBoard.org](https://beagleboard.org/),to know more about the Organization and its working culture.<br>
In the early stages of exploring the codebase of simpPRU,I had a bit of difficulty in understanding the process of its working.The lexer,parser was comprehensible but the further part from the integration of Codeprinter to print the values,expressions that were stored in ast was the main part which I could not catch at the first place but once understood I was through with it.<br>

The culmination week was here which was the decider for the selections,Anxiety and excitement was at its peak to know the results.On May 18,there was some activity on the GSoC dashboard where the proposals were rejected or just a blank,this created a lot of anxiousness and panic for the coming times.Finally,it was May 20,2022 and what I was longing for was in front of me,![Acceptance](/assets/acceptance.jpeg)<br> 



## Coding period
Now getting into the Coding Period after the selection procedure where we had a [Introductory meet](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjdk-aDuPj4AhWdxjgGHap5BeQQtwJ6BAgGEAI&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D8FW5SziGzD4&usg=AOvVaw0sWnEWysJjN4OQqplzd57V) for all the GSoC students of the current year 2022 in BeagleBoard.Org.<br>

Kicking off with the intial phase of coding I went through the PRU CookBook to know more about PRU and its working.I had a pocketbeagle with which I was experimenting with simpPRU console and trying out basic examples.
The first task of coding started with adding python testsuite to Github Actions.I was ready with this by adding the python test script in .yml but it failed on arm32 as setup@python does not work for arm and a Dockerfile had to be written to overcome this.Next I tried out the arm32v7 image for python in Dockerfile but even that did not turn out well.I familiarized myself with docker was trying to use the original image with apt install python3 but did not change the build script.
```
echo "Running make"
make -j 8

echo "Running make install"
make install

echo "Running make package"
make package

echo "testing simppru"
cd ..
python3 test.py <-----
```
But this was the catch where the python script had to be run after compiled binary in build script.Vedant merged this for which I was stuck for a while and the Github Actions now succesfully ran the testscript giving the results for testcases.<br>

Now there were two new problems which came into limelight that even though the tests failed in the Github Actions it gave a green signal as the .sim files(testcases) ran succesfully irrespective of its output.Pratim Ugale suggested that we should add an exit code so that Github Actions can display the bug in testing script.This script in Actions had to be successful only if script in Actions passed so for this I added the exit code for failure of testcases which gives a failure in Github Actions in case of error/bug in testcase.<br>
THe second bug which arised was arm32 was failing in one testcase where it gave a different output unlike the expected one.It was a hexadecimal number which had to negated,for edge cases as such strtol() gave a width of 32 bits for reading the input.
```
{integer}               {
  /*octal if first digit is 0, hexadecimal if first two characters are 0x or 0X, decimal otherwise*/
  yylval.integer = strtol(yytext, NULL, 0);
  return CONST_INT;
}
```

So as to resolve this I used strtoll() to provide a 64 width for input which works well with this.<br>

Entering into the Week2 I had planned the Auto-toggle button for the PRU Status,for this I had to see the condition for the state of the PRU whether **running** or **offline** in the remoteproc.<br>
```
    int bits_read = read(remoteproc_start, state, sizeof(char)*7);

    if (!strcmp(state, "offline") && bits_read > 0)
    {
        k=0;
    }
    else
    {
        k=1;
    }
```
The button is designed as an autotoggle which depending on the state of PRU gives the highlight of green which means on and red for off.This gives an intuition about the status of the PRU you are working on.The PRU you load on is the one which you can see the status.<br>
```
Component button = Button(" PRU ", NULL);
```

This button is generated with an empty function for Button Component in FTUXI due to which it does not eed a manual click and goes for an uncontrolled exit on a click.![PRU-STATUS](/assets/prustatus.jpg)<br>

For the week3,I had already planned and was ready with half of the work to be done which I had done in the pre-gsoc period as this part was a bit easy.I had planned to add the Add,Subtract,Multiply and Divide assignment operators covering the basic operations which would be really useful for computation and in a faster way.I just had to test thoroughly for its working in simppru and simmpru-console.Many a times I used to run the current simppru rather using generated binary simppru which was updated.
Archisman addressed me with this part and adviced me the to check the generated C file whether things intended are printed in the correct way.

