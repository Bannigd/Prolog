% Copyright

implement main
    open core, stdio, file

class facts - cinemaDb
    cinema : (string CinemaName, real CRating).
    film : (string Title, integer Duration, real TRating).
    session : (string CinemaName, string Title, string Time, integer Cost).
    noon : (string Time).
    day : (string Time).
    evening : (string Time).

domains
    sesItem = sesItem(string CinemaName, string Time, integer Cost).

class predicates
    print_list : (sesItem* SesList).
clauses
    print_list([]).
    print_list([sesItem(CName, Time, Cost) | T]) :-
        write(CName, ' ', Time, ' ', Cost),
        nl,
        print_list(T).

class predicates
    find_all_sessions : (string Title) -> sesItem* SesList.
clauses
    find_all_sessions(Title) = [ sesItem(CName, Time, Cost) || session(CName, Title, Time, Cost) ].

class predicates
    filter_max_cost : (string Title, integer MaxCost) -> sesItem* SesList.
clauses
    filter_max_cost(Title, MaxCost) = List :-
        List =
            [ sesItem(CName, Time, Cost) ||
                session(CName, Title, Time, Cost),
                Cost <= MaxCost
            ].

class predicates
    count_sessions : (sesItem* SesList) -> integer Number.
    sum_costs : (sesItem* SesList) -> integer Sum.
    average_cost : (sesItem* SesList) -> real Average determ.

clauses
    count_sessions([]) = 0.
    count_sessions([_ | T]) = count_sessions(T) + 1.

    sum_costs([]) = 0.
    sum_costs([sesItem(_, _, Cost) | T]) = sum_costs(T) + Cost.

    average_cost(SesList) = sum_costs(SesList) / Number :-
        Number = count_sessions(SesList),
        Number > 0.

class predicates
    noon_sessions : (sesItem*) -> sesItem*.
clauses
    noon_sessions(SesList) =
        [ sesItem(CName, Time, Cost) ||
            sesItem(CName, Time, Cost) in SesList,
            noon(Time)
        ].

class predicates
    day_sessions : (sesItem*) -> sesItem*.
clauses
    day_sessions(SesList) =
        [ sesItem(CName, Time, Cost) ||
            sesItem(CName, Time, Cost) in SesList,
            day(Time)
        ].

class predicates
    evening_sessions : (sesItem*) -> sesItem*.
clauses
    evening_sessions(SesList) =
        [ sesItem(CName, Time, Cost) ||
            sesItem(CName, Time, Cost) in SesList,
            evening(Time)
        ].

clauses
    run() :-
        consult("../data.txt", cinemaDb),
        fail.
    run() :-
        L = find_all_sessions('Матрица'),
        print_list(L),
        Count_L = count_sessions(L),
        Average_L = average_cost(L),
        write(Count_L, ' ', Average_L),
        nl,
        fail.
    run() :-
        M = filter_max_cost('Матрица', 300),
        nl,
        write('Сеансы дешевле 300 рублей'),
        nl,
        print_list(M),
        Count_M = count_sessions(M),
        Average_M = average_cost(M),
        write(Count_M, ' ', Average_M),
        nl,
        fail.
    run() :-
        N = find_all_sessions('Матрица'),
        N_noon = noon_sessions(N),
        N_day = day_sessions(N),
        N_evening = evening_sessions(N),
        nl,
        print_list(N),
        nl,
        nl,
        print_list(N_noon),
        nl,
        print_list(N_day),
        nl,
        print_list(N_evening),
        nl,
        fail.
    run().

end implement main

goal
    console::runUtf8(main::run).
