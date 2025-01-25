So, the goal of my project here is to build a Gym Tracker app, which lets users create workout routines and track their individual workout sessions. A routine is meant to serve as a template the user can follow to start their session, and in the session, they can make some edits to the exercises they selected and such if they wish.

Some key features will include:
- User Auth: A user will login and then never be asked to login again if they close and reopen the app. They will only be signed out once they explicitly click to sign out on their profile page.
- Exercise selection: A user can view a list of the exercises they can add to their workout routines/sessions. This will also include some general tips for the exercises (steps on how to perform the exercise), the muscle group it targets, and whether it is a barbell, dumbbell, machine, or bodyweight exercise. In a future version of this app, I would also like to include short animated videos of how to do the exercises.
- Exercise creation: A user should be able to create new exercises, and specify whether it is a barbell, dumbbell, machine, or bodyweight exercise, and which muscle group it's targeting. They should also state whether the exercise is done one arm/leg at a time.
- Exercise deletion: A user should be able to delete an exercise, and remove it from the app.
- Routine creation: A user should be able to create new routines, and specify which exercises they want to include in the routine. They should also be able to specify the number of sets and optionally set a range of reps for each exercise. Also, they should optionally be able to specify the rest time between sets.
- Routine deletion: A user should be able to delete their routine, and remove it from the app.
- Set Customization: A user can label sets as warmup, working, a drop set (which would be connected to the previous set), or a set to failure.
- Supersets: The block for one exercise can be connected to another exercise to make a superset.
- Session creation: A user should be able to create a new session, and specify which routine they want to follow (or none at all, and manually add exercises to the session). They should also be able to specify the weight they want to use for each set of an exercise, and the reps they want to do for each exercise.
- Workout session history: A user should be able to track their sessions. They can view a list of all their sessions, and see the exercises they did in each session with the amount of sets. If they click on a session, they can see more details on the session, including the weight they used for each set, the reps they did for each set, and what sets were warmup, working, a drop set, superset, or a set to failure.
- Session history editing: A user should be able to edit their session, and make changes to the exercises they selected, the weight they're using, and the reps they're doing.
- Session historydeletion: A user should be able to delete their session, and remove it from the app.
- Workout programs: A user should be able to create a workout program, and specify which routines they want to include in the program.
- Charts: A user should be able to view charts of their progress per exercise. They can view chart based on a specific weight (measuring max reps at that weight), or a specific range of reps (measuring max weight at that range of reps).
- Settings page: A user can view premium membership info, delete their account, log out, set when they should be reminded to workout, and more features that will be decided on later.
- Premium membership features: Charts, other stuff to be decided on later.

Currently In Progress:
- User Auth