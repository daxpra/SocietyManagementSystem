package model;

import java.util.*;

public class Graph {

    private Map<String, List<String>> adjList = new HashMap<>();

    // Add connection (edge)
    public void addEdge(String from, String to) {
        adjList.computeIfAbsent(from, k -> new ArrayList<>()).add(to);
    }

    // Get graph
    public Map<String, List<String>> getGraph() {
        return adjList;
    }
}