#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};
struct Node* make_node(int val);
struct Node* insert(struct Node* root, int val);
struct Node* get(struct Node* root, int val);
int getAtMost(int val, struct Node* root);
int main() {
    struct Node* root = NULL;
    root = insert(root, 5);
    root = insert(root, 3);
    root = insert(root, 7);
    root = insert(root, 1);
    root = insert(root, 4);

    // test get
    struct Node* found = get(root, 3);
    printf("get(3) = %d\n", found->val);   // 3

    struct Node* missing = get(root, 9);
    printf("get(9) = %p\n", (void*)missing);  // NULL

    // test getAtMost
    printf("getAtMost(4) = %d\n", getAtMost(4, root));  // 3
    printf("getAtMost(5) = %d\n", getAtMost(5, root));  // 4
    printf("getAtMost(7) = %d\n", getAtMost(7, root));  // 5
    printf("getAtMost(0) = %d\n", getAtMost(0, root));  // 0

    return 0;
}
