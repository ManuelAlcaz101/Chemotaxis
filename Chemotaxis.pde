Zombie[] zombies; // Array to hold zombie instances
ArrayList<Human> humans; // Use ArrayList for dynamic human instances
int numberOfZombies = 50; // Initial number of zombies
int numberOfHumans = 20; // Initial number of humans

void setup() {
    size(800, 800); // Set the size of the window
    zombies = new Zombie[numberOfZombies]; // Initialize the zombie array
    humans = new ArrayList<Human>(); // Initialize the ArrayList for humans

    // Create zombies with random positions and colors
    for (int i = 0; i < numberOfZombies; i++) {
        int randomX = (int) random(width); // Random X position within the window
        int randomY = (int) random(height); // Random Y position within the window
        zombies[i] = new Zombie(randomX, randomY, color(0, 255, 0)); // Green color for zombies
    }

    // Create humans with random positions and colors
    for (int i = 0; i < numberOfHumans; i++) {
        int humanX = (int) random(width); // Random X position for human
        int humanY = (int) random(height); // Random Y position for human
        humans.add(new Human(humanX, humanY, color(255, 0, 0))); // Red color for human
    }
}

void draw() {
    background(255); // Clear the background

    // Update and display each human
    for (int i = humans.size() - 1; i >= 0; i--) { // Iterate in reverse to safely remove elements
        Human h = humans.get(i);
        h.runAway(zombies); // Move each human away from zombies
        h.show(); // Display the human

        // Check if the human is caught by a zombie
        if (h.isCaught(zombies)) {
            // Turn the human into a zombie
            Zombie newZombie = new Zombie(h.x, h.y, color(0, 255, 0)); // New zombie at human's position
            addZombie(newZombie);
            // Remove the caught human
            humans.remove(i); // Remove the caught human
            // Spawn a new human
            spawnNewHuman();
        }
    }

    // Update and display each zombie
    for (Zombie z : zombies) {
        z.chase(humans); // Move the zombie towards the closest human
        z.show(); // Display the zombie
    }
}

// Method to add a new zombie to the zombie array
void addZombie(Zombie newZombie) {
    Zombie[] newZombies = new Zombie[zombies.length + 1];
    for (int i = 0; i < zombies.length; i++) {
        newZombies[i] = zombies[i];
    }
    newZombies[newZombies.length - 1] = newZombie; // Add new zombie
    zombies = newZombies; // Update the zombie array
}

// Method to spawn a new human
void spawnNewHuman() {
    int humanX = (int) random(width); // Random X position for new human
    int humanY = (int) random(height); // Random Y position for new human
    humans.add(new Human(humanX, humanY, color(255, 0, 0))); // Red color for new human
}

// Zombie class definition
class Zombie {
    int x; // X-coordinate
    int y; // Y-coordinate
    color zombieColor; // Color of the zombie
    float speed = 0.5; // Speed of the zombie

    Zombie(int startX, int startY, color zombieColor) {
        this.x = startX;
        this.y = startY;
        this.zombieColor = zombieColor;
    }

    void chase(ArrayList<Human> humans) {
        if (humans.size() > 0) {
            Human closestHuman = humans.get(0);
            float minDistance = dist(x, y, closestHuman.x, closestHuman.y);

            // Find the closest human
            for (Human h : humans) {
                float distance = dist(x, y, h.x, h.y);
                if (distance < minDistance) {
                    closestHuman = h;
                    minDistance = distance;
                }
            }

            // Move towards the closest human
            if (x < closestHuman.x) {
                x += speed; // Move right
            } else if (x > closestHuman.x) {
                x -= speed; // Move left
            }

            if (y < closestHuman.y) {
                y += speed; // Move down
            } else if (y > closestHuman.y) {
                y -= speed; // Move up
            }
        } else {
            // Randomly change direction if no humans are available
            x += random(-speed, speed);
            y += random(-speed, speed);
        }

        // Keep the zombie within canvas boundaries
        x = constrain(x, 0, width - 20); // Assuming zombie width is 20
        y = constrain(y, 0, height - 20); // Assuming zombie height is 20
    }

    void show() {
        fill(zombieColor);
        rect(x, y, 20, 20); // Draw the zombie as a square
    }
}

// Human class definition
class Human {
    int x; // X-coordinate
    int y; // Y-coordinate
    color humanColor; // Color of the human
    float speed = 2; // Speed of the human

    Human(int startX, int startY, color humanColor) {
        this.x = startX;
        this.y = startY;
        this.humanColor = humanColor;
    }

    void runAway(Zombie[] zombies) {
        Zombie nearestZombie = zombies[0];
        float minDistance = dist(x, y, nearestZombie.x, nearestZombie.y);
        
        // Find the closest zombie
        for (Zombie z : zombies) {
            float distance = dist(x, y, z.x, z.y);
            if (distance < minDistance) {
                nearestZombie = z;
                minDistance = distance;
            }
        }

        // Move away from the nearest zombie
        if (x < nearestZombie.x) {
            x -= speed; // Move left
        } else if (x > nearestZombie.x) {
            x += speed; // Move right
        }

        if (y < nearestZombie.y) {
            y -= speed; // Move up
        } else if (y > nearestZombie.y) {
            y += speed; // Move down
        }

        // Keep the human within canvas boundaries
        x = constrain(x, 0, width - 15); // Assuming human width is 15
        y = constrain(y, 0, height - 15); // Assuming human height is 15
    }

    void show() {
        fill(humanColor);
        ellipse(x, y, 15, 15); // Draw the human as a circle
    }

    boolean isCaught(Zombie[] zombies) {
        for (Zombie z : zombies) {
            if (dist(x, y, z.x, z.y) < 15) { // If the distance is less than a threshold
                return true; // Caught by a zombie
            }
        }
        return false; // Not caught
    }
}
