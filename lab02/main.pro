% Copyright

implement main
    open core, stdio, file

class facts - cinemaDb
    cinema : (string CinemaName, real CRating) nondeterm.
    film : (string Title, integer Duration, real TRating) nondeterm.
    session : (string CinemaName, string Title, string Time, integer Cost) nondeterm.
    noon : (string Time) nondeterm.
    day : (string Time) nondeterm.
    evening : (string Time) nondeterm.

class predicates
    print_session : (string CinemaName, integer Duration, integer TRating, string Time, integer Cost) nondeterm anyflow.
clauses
    print_session(CName, Duration, TRating, Time, Cost) :-
        cinema(CName, CRating),
        session(CName, Title, Time, _),
        write(CName, ", ", CRating, ": ", Title, ", ", Duration, " мин., ", TRating, ", ", Time, ", ", Cost, " рублей\n"),
        fail.

class predicates
    find_all_sessions : (string Title) nondeterm anyflow.
clauses
    find_all_sessions(Title) :-
        cinema(CName, CRating),
        film(Title, Duration, TRating),
        session(CName, Title, Time, Cost),
        print_session(CName, Duration, TRating, Time, Cost),
        fail.

class predicates
    filter_max_cost : (string Title, integer MaxCost) nondeterm anyflow.
clauses
    filter_max_cost(Title, MaxCost) :-
        film(Title, Duration, TRating),
        session(CName, Title, Time, Cost),
        Cost <= MaxCost,
        print_session(Title, Duration, TRating, Time, Cost),
        fail.

class predicates
    filter_rating : (integer MinRating) nondeterm anyflow.
clauses
    filter_rating(MinRating) :-
        film(Title, Durtion, TRating),
        TRating >= MinRating,
        write(Title, " ", TRating, "\n"),
        fail.

class predicates
    noon_sessions : (string Title) nondeterm anyflow.
clauses
    noon_sessions(Title) :-
        film(Title, Duration, TRating),
        session(CName, Title, Time, Cost),
        noon(Time),
        print_session(Title, Duration, TRating, Time, Cost),
        fail.

class predicates
    day_sessions : (string Title) nondeterm anyflow.
clauses
    day_sessions(Title) :-
        film(Title, Duration, TRating),
        session(CName, Title, Time, Cost),
        day(Time),
        print_session(Title, Duration, TRating, Time, Cost),
        fail.

class predicates
    evening_sessions : (string Title) nondeterm anyflow.
clauses
    evening_sessions(Title) :-
        film(Title, Duration, TRating),
        session(CName, Title, Time, Cost),
        evening(Time),
        print_session(Title, Duration, TRating, Time, Cost),
        fail.

class predicates
    total_cost : (string Title, string CName, string Time, integer Count) nondeterm anyflow.
clauses
    total_cost(Title, CName, Time, Count) :-
        session(CName, Title, Time, Cost),
        Sum = Cost * Count,
        write("Общая стоимость: ", Sum),
        nl,
        fail.

class facts
    count : (integer N) single.

clauses
    count(0).

class predicates
    repeat : () multi.
    count_sessions : (string Title) nondeterm.

clauses
    repeat().
    repeat() :-
        repeat().

    count_sessions(Title) :-
        write("Фильм: ", Title),
        nl,
        assert(count(0)),
        %repeat(),
        session(CName, Title, Time, Cost),
        count(N),
        assert(count(N + 1)),
        write(CName, " ", Time, " ", Cost),
        nl,
        fail.
    count_sessions(_) :-
        count(N),
        write("Всего сеансов: ", N),
        nl.

clauses
    run() :-
        consult("../data.txt", cinemaDb),
        fail.
    run() :-
        count_sessions("1+1"),
        nl,
        fail.
    run() :-
        total_cost("Матрица", "Звезда", "18-40", 5),
        fail.
    run().

end implement main

goal
    console::runUtf8(main::run).
