/////////////////////////////////////////////////////////////////////////
//                  Dijkstra's Algorithm
// written for: e-yrc 2022-23 - Team SB3467
// Authors: AyushJam and Shashidhar Hegde
// Date: 18.11.22
// Special thanks: Kishore and Arjun
//
// About the code
// 1. Used arrays
// 2. Input has to be written inside the code
// 3. Follows a rectangular grid with NESW directions for indices 0 to 3.
// 4. Other details explained in comments.
//
/////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>

int main()
{
    // graph[node number][neighbour number][0] = node number
    // graph[node number][neighbour number][1] = distance
    // neighbour number 0 to 3
    // node number 0 to N-1
    int graph[8][4][2];

    // in the below example
    // 0 to 6 - 7 nodes are used and index 7 corresponds to infinity
    // Distance to infinity is 100 units
    // 0th neighbour is North, 2 is East
    // See the graph used below
    /*
        A-----5-----E-----2
        |           |     |
        1           4     |
        |           |     |
        B-----3-----D--1--H
        |           |     |
        2           4     |
        |           |     |
        C-----4-----F-----2

        graph[3][1][0] = 6;
        => node[3] is D, its properties are asserted
        => the Eastern neighbour [1]'s index is ...[0] = 6 (H),

        graph[3][1][1] = 1;
        => ...[1] index 1 of dimension-3 is distance = 1
    */

    graph[0][0][0] = 7;
    graph[0][0][1] = 100;
    graph[0][1][0] = 4;
    graph[0][1][1] = 5;
    graph[0][2][0] = 1;
    graph[0][2][1] = 1;
    graph[0][3][0] = 7;
    graph[0][3][1] = 100;
    graph[1][0][0] = 0;
    graph[1][0][1] = 1;
    graph[1][1][0] = 3;
    graph[1][1][1] = 3;
    graph[1][2][0] = 2;
    graph[1][2][1] = 2;
    graph[1][3][0] = 7;
    graph[1][3][1] = 100;
    graph[2][0][0] = 1;
    graph[2][0][1] = 2;
    graph[2][1][0] = 5;
    graph[2][1][1] = 4;
    graph[2][2][0] = 7;
    graph[2][2][1] = 100;
    graph[2][3][0] = 7;
    graph[2][3][1] = 100;
    graph[3][0][0] = 4;
    graph[3][0][1] = 4;
    graph[3][1][0] = 6;
    graph[3][1][1] = 1;
    graph[3][2][0] = 5;
    graph[3][2][1] = 4;
    graph[3][3][0] = 1;
    graph[3][3][1] = 3;
    graph[4][0][0] = 7;
    graph[4][0][1] = 100;
    graph[4][1][0] = 6;
    graph[4][1][1] = 2;
    graph[4][2][0] = 3;
    graph[4][2][1] = 4;
    graph[4][3][0] = 0;
    graph[4][3][1] = 5;
    graph[5][0][0] = 3;
    graph[5][0][1] = 4;
    graph[5][1][0] = 6;
    graph[5][1][1] = 2;
    graph[5][2][0] = 7;
    graph[5][2][1] = 100;
    graph[5][3][0] = 2;
    graph[5][3][1] = 4;
    graph[6][0][0] = 4;
    graph[6][0][1] = 2;
    graph[6][1][0] = 7;
    graph[6][1][1] = 100;
    graph[6][2][0] = 5;
    graph[6][2][1] = 2;
    graph[6][3][0] = 3;
    graph[6][3][1] = 1;

    // a table to store distances and last visited nodes
    int tickets[7][2] = {0};
    // tickets[node_number][0] = distance from node snode
    // tickets[node_number][1] = last visited node number
    for (int i = 0; i < 7; i++)
    {
        tickets[i][0] = 100;
    }

    // start at node_s
    int snode = 1;
    int enode = 6;

    int visited_nodes[7] = {0, 0, 0, 0, 0, 0, 0};

    tickets[snode][0] = 0;
    tickets[snode][1] = 7;

    int present_node = snode;
    int next_shortest_dist = 0;

    while (!visited_nodes[enode])
    {
        for (int i = 0; i < 4; i++)
        {
            // first update distance in tickets
            // distance of ith neighbour from present_node

            if (!visited_nodes[graph[present_node][i][0]])
            {
                if (tickets[graph[present_node][i][0]][0] > (graph[present_node][i][1] + tickets[present_node][0]))
                {
                    tickets[graph[present_node][i][0]][0] = graph[present_node][i][1] + tickets[present_node][0];
                    tickets[graph[present_node][i][0]][1] = present_node;
                }
            }
        }

        // now mark the present node visited
        visited_nodes[present_node] = 1;

        // now which node should it go to?
        // the least distance in tickets
        // find least distance and update present node
        next_shortest_dist = 100; // to start the loop, the first value
        for (int j = 0; j < 7; j++)
        {
            if ((!visited_nodes[j]) && (tickets[j][0] < next_shortest_dist))
            {
                next_shortest_dist = tickets[j][0];
                present_node = j;
            }
        }
        // next node is hence found
        // printf("next_node = %d\n", present_node);
    }

    for (int i = 0; i < 7; i++)
        printf("visited_nodes[%d] = %d \n", i, visited_nodes[i]);

    // Now find shortest path and the distance
    // Path - trace it backwards
    int path[10] = {0};
    int prev_node = tickets[enode][1];
    path[0] = enode;
    int k = 1;

    while (prev_node != snode)
    {
        path[k] = prev_node;
        k++;
        prev_node = tickets[prev_node][1];
    }
    path[k] = snode;

    // now reverse the array
    int shortest_path[k + 1];

    printf("Shortest Path -> ");
    for (int i = 0; i < k + 1; i++)
    {
        shortest_path[i] = path[k - i];
        printf("%d ", shortest_path[i]);
    }

    // Distance
    int shortest_distance = tickets[enode][0];
    printf("\nShortest Distance = %d", shortest_distance);

    return 0;
}
