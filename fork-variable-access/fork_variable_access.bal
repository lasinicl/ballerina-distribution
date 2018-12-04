import ballerina/io;

// The in scope variables can be accessed by the workers inside the fork statement.
public function main() {
    // These variables can be accessed by the forked workers.
    int i = 100;
    string s = "WSO2";
    map<string> m = { "name": "Bert", "city": "New York", "postcode": "10001"};

    string name = <string> m["name"];
    string city = <string> m["city"];
    string postcode = <string> m["postcode"];
    io:println("[default worker] before fork: value of name is [",
        name , "] value of city is [", city, "] value of postcode is [",
        postcode, "]");

    // Declare the fork statement.
    fork {
        worker W1 {
            // Change the value of the integer variable `i` within the worker W1.
            i = 23;
            // Change value of map variable `m` within the worker W1.
            m["name"] = "Moose";

            fork {
                worker W3 {
                    // Change value of map variable `m` within the child worker W3 of W1.
                    string street = "Wall Street";
                    m["street"] = street;

                    // Change the value of integer variable `i` within the worker W3.
                    i = i + 100;
                }
            }
        }

        worker W2 {
            // Change the value of string variable `s` within the worker W2.
            s = "Ballerina";
            // Change the value of map variable `m` within the worker W2.
            m["city"] = "Manhattan";
        }
    }

    // Wait for W1 and W2 to finish
    any res = wait {W1, W2};

    // Print the values after the fork statement to check the values of the variables.
    // The value type variables have not changed since they are passed in as a copy of the original variable.
    io:println("[default worker] after fork: " +
               "value of integer variable is [", i, "] ",
               "value of string variable is [", s, "]");
    // The reference type variables' internal content has got updated since they are passed in
    // as a reference to the workers.
    name = <string> m["name"];
    city = <string> m["city"];
    // Get value of the new field added to map variable `m` inside worker W3
    string street = <string> m["street"];

    io:println("[default worker] after fork: " +
               "value of name is [", name,
               "] value of city is [", city, "] value of street is [", street,
               "] value of postcode is [", postcode, "]");
}
