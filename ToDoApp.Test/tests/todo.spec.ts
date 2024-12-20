import { test, expect, type Page } from '@playwright/test';

const username = createUsername(8) + '@example.com';
const password = 'P@ssword1';

test.beforeEach(async ({ page }) => {
  //register new user (Could also use request to do this directly with API) or do it on the backend
  await page.goto('/signup');
  await page.getByPlaceholder('Email').fill(username);
  await page.getByPlaceholder('Password', {exact: true}).fill(password);
  await page.getByPlaceholder('Confirm Password').fill(password);
  await page.getByRole('button', { name: 'Signup' }).click();
  
  //Authenticate new user
  await page.waitForURL('/login');
  await page.getByPlaceholder('Email').fill(username);
  await page.getByPlaceholder('Password').fill(password);
  await page.getByRole('button', { name: 'Login' }).click();

  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL('/');
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.getByRole('heading', { name: 'To Do' })).toBeVisible();

  // End of authentication steps.
  
  await page.goto('/');
});

const TODO_ITEMS = [
  'buy some cheese',
  'feed the cat',
  'book a doctors appointment'
] as const;

test.describe('ToDo Tests', () => {
  test('should allow me to add todo items', async ({ page }) => {

    let currentItems = page.getByRole('listitem');
    console.log(currentItems);
    // create a new todo locator
    const newTodo = page.getByPlaceholder('To Do');

    // Create 1st todo.
    await newTodo.fill(TODO_ITEMS[0]);
    await newTodo.press('Enter');

    // Make sure the list only has one todo item.
    await expect(page.getByRole('listitem')).toHaveText([
      TODO_ITEMS[0]
    ]);

    // Create 2nd todo.
    await newTodo.fill(TODO_ITEMS[1]);
    await newTodo.press('Enter');

    // Make sure the list now has two todo items.
    await expect(page.getByRole('listitem')).toHaveText([
      TODO_ITEMS[0],
      TODO_ITEMS[1]
    ]);

  });

  test('should clear text input field when an item is added', async ({ page }) => {
    // create a new todo locator
    const newTodo = page.getByPlaceholder('To Do');

    // Create one todo item.
    await newTodo.fill(TODO_ITEMS[0]);
    await newTodo.press('Enter');

    // Check that input is empty.
    await expect(newTodo).toBeEmpty();
  });

  test('should append new items to the bottom of the list', async ({ page }) => {
    // Create 3 items.
    await createDefaultTodos(page);
  
    // Check test using different methods.
    await expect(page.getByRole('listitem')).toHaveCount(3);

  });

  test('should be able to complete items', async ({ page }) => {
    // Create 3 items.
    await createDefaultTodos(page);
  
    await page.locator('li').filter({ hasText: TODO_ITEMS[0] }).getByRole('checkbox').check();

    await expect(page.getByText(TODO_ITEMS[0])).toHaveClass("form-check-label fs-4 todo-done");

  });

  test('should be able to delete items', async ({ page }) => {
    // Create 3 items.
    await createDefaultTodos(page);
  

    await page.locator('li').filter({ hasText: TODO_ITEMS[0] }).getByTestId('trash-can').click();
    await page.locator('li').filter({ hasText: TODO_ITEMS[1] }).getByTestId('trash-can').click();

    await expect(page.getByRole('listitem')).toHaveCount(1);

    await expect(page.getByRole('listitem')).toHaveText(TODO_ITEMS[2]);
    await expect(page.getByRole('listitem')).not.toHaveText([TODO_ITEMS[0], TODO_ITEMS[1]])

  });
});


  async function createDefaultTodos(page: Page) {
    // create a new todo locator
    const newTodo = page.getByPlaceholder('To Do');

    for (const item of TODO_ITEMS) {
      await newTodo.fill(item);
      await newTodo.press('Enter');
      await expect(newTodo).toBeEmpty();
    }
  }

  function createUsername(length: number) {
    const randomLetter = () => String.fromCharCode(0 | Math.random() * 26 + 97)

    let username = "";

    let counter = 0;
    while (counter < length) {
      username += randomLetter();
      counter += 1;
    }

    return username;
  }

