public class Particle {
    // current & start value
    private int x, y, c, rng;
    private float ax, ay;
    private float vx, vy;
    public float px, py;
    private boolean selected;

    // end value
    private int endX, endY, endColor;

    private PImage image;

    // set constructor
    public Particle(int x, int y, int c, float vx, float vy) {
        this.x = x;
        this.y = y;
        this.c = c;
        this.vx = vx;
        this.vy = vy;
        this.ax = 0;
        this.ay = 0.2f;
        this.selected = false;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public int getC() {
        return c;
    }

    public int getRng() {
        return rng;
    }

    public void setRng(int rng) {
        this.rng = rng;
    }

    public float getAx() {
        return ax;
    }

    public float getAy() {
        return ay;
    }

    public float getVx() {
        return vx;
    }

    public void setVx(float vx) {
        this.vx = vx;
    }

    public float getVy() {
        return vy;
    }

    public void setVy(float vy) {
        this.vy = vy;
    }

    public int getEndX() {
        return endX;
    }

    public void setEndX(int endX) {
        this.endX = endX;
    }

    public int getEndY() {
        return endY;
    }

    public void setEndY(int endY) {
        this.endY = endY;
    }

    public int getEndColor() {
        return endColor;
    }

    public void setEndColor(int endColor) {
        this.endColor = endColor;
    }

    public PImage getImage() {
        return image;
    }

    public void setImage(PImage image) {
        this.image = image;
    }

    public boolean isSelected() {
        return selected;
    }

    public void select() {
        this.selected = true;
    }

    public void deselect() {
        this.selected = false;
    }
}
