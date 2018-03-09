# Contributing to Ralyxa

1. Have tests.

## The basic idea

Ralyxa is in two parts: 

1. The user-facing Ruby interface which looks a bit like Sinatra.
2. The under-the-hood Ruby-to-JSON translator which directly references Alexa structures.

This gives rise to some principles:

1. The user-facing Ruby interface should try to provide thoughtful abstractions to the Alexa structures.
2. The under-the-hood Ruby-to-JSON translator should contain objects which directly map onto Alexa structures.

Some other principles:

1. Keep the user-facing Ruby interface as simple as possible. Imagine a brand-new Ruby developer using this.