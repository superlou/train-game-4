import pandas as pd
import random
import json


def load_wikipedia_table() -> pd.Series:
    # https://en.wikipedia.org/wiki/List_of_Amtrak_stations
    df = pd.read_excel("amtrak_wikipedia.xlsx", sheet_name="active")
    df = df.dropna(subset="Station")
    active_stations = df.Station.str.strip()
    
    df = pd.read_excel("amtrak_wikipedia.xlsx", sheet_name="suspended")
    df = df.dropna(subset="Station")
    suspended_stations = df.Station.str.strip()

    stations = pd.concat([active_stations, suspended_stations])

    return stations


def build_model(examples:list[str], order:int):
    counts : dict[str, dict[str, int]] = {}

    for example in examples:
        example = ("^" * order) + example + "$"

        for i in range(order, len(example)):
            state = example[i - order:i]
            token = example[i]

            if state in counts:
                if token in counts[state]:
                    counts[state][token] += 1
                else:
                    counts[state][token] = 1
            else:
                counts[state] = {}
                counts[state][token] = 1

    transition_table : dict[str, (list, list)] = {}

    for state in counts.keys():
        total = sum(counts[state].values())
        tokens = []
        probs = []

        for token, count in counts[state].items():
            tokens.append(token)
            probs.append(count / total)

        transition_table[state] = (tokens, probs)

    return transition_table


def pick_next(transition_table, state:str) -> str:
    tokens, probs = transition_table[state]
    return random.choices(tokens, probs)[0]


def generate(transition_table, order) -> str:
    word = "^" * order
    i = order

    while word[-1] != "$":
        word += pick_next(transition_table, word[i - order:i])
        i += 1

    return word[order:-1]


def main():
    order = 3
    stations = load_wikipedia_table()
    transition_table = build_model(stations.tolist(), order)

    model = {
        "transition_table": transition_table,
        "order": order,
    }

    json.dump(model, open("station_name_markov.json", "w"))

    for i in range(10):
        print(generate(transition_table, order))


if __name__ == "__main__":
    main()