# ThnkWell
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "thnk_well"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install thnk_well
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

---

---
To set a background image for only one specific view in a Ruby on Rails application, you'll need to isolate the CSS so it only affects that particular view. Here's a step-by-step guide to achieve this:

1. **Create a Unique CSS Class or ID for Your View**:
    - First, identify or create a unique class or ID for the main container of your specific view. For instance, if your view is for a user profile, you might use something like `<div id="user-profile">`.

2. **Add Your Background Image in a Separate CSS File**:
    - Create a new CSS file in `app/assets/stylesheets/`, like `user_profile.css`.
    - In this file, define your background image using the unique class or ID. For example:
      ```css
      #user-profile {
          background-image: url('path_to_your_image.jpg'); /* Replace with the actual path */
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
      }
      ```
    - Remember to update the path to your image appropriately.

3. **Prevent Global Asset Loading**:
    - Modify `application.css` to prevent it from globally loading all CSS files.
    - Instead of using `*= require_tree .`, you can require individual stylesheets or exclude the stylesheet for your specific view.

4. **Include the Stylesheet in Your View**:
    - In the specific view where you want the background, include your new stylesheet. You can do this in the corresponding view's layout file, or directly in the view if you're not using a specific layout.
    - Use the `stylesheet_link_tag` helper to include your stylesheet. For example:
      ```erb
      <%= stylesheet_link_tag 'user_profile' %>
      ```

5. **Ensure Proper Precompilation for Production**:
    - If you're deploying to production, remember to add your new stylesheet to the precompile list in `config/initializers/assets.rb`:
      ```ruby
      Rails.application.config.assets.precompile += %w( user_profile.css )
      ```

6. **Adjust the HTML Structure of Your View**:
    - Ensure that the main container of your view has the ID or class you targeted in your CSS. For example:
      ```html
      <div id="user-profile">
        <!-- Content of your view goes here -->
      </div>
      ```

7. **Test Your Changes**:
    - Test the view both in development and production modes to ensure the background image is applied correctly and doesn’t affect other views.

By following these steps, you can set a background image that is specific to one view without affecting the global styling of your application. This approach keeps your styles modular and maintainable.

If you're using Tailwind CSS with Ruby on Rails and want to apply a specific background image for one view using a Tailwind CSS file (like `user_profile.tailwind.css`), you can follow a similar approach with some adjustments to fit the Tailwind ecosystem. Here's how you can do it:

1. **Create a Tailwind CSS File**:
    - Create a new CSS file, like `user_profile.tailwind.css`, in the `app/assets/stylesheets/` directory.

2. **Define Your Custom Styles**:
    - In this file, you can define your custom styles. If Tailwind CSS doesn't have a utility class for your specific background image, you can write it as plain CSS:
      ```css
      #user-profile {
          background-image: url('path_to_your_image.jpg'); /* Replace with the actual path */
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
      }
      ```
    - Alternatively, you can use Tailwind's `@apply` directive to apply utility classes within your custom CSS:
      ```css
      #user-profile {
          @apply bg-cover bg-center bg-no-repeat;
          background-image: url('path_to_your_image.jpg');
      }
      ```

3. **Import Tailwind Directives**:
    - At the top of your `user_profile.tailwind.css`, make sure to import Tailwind's base, components, and utilities:
      ```css
      @import "tailwindcss/base";
      @import "tailwindcss/components";
      @import "tailwindcss/utilities";
      ```
    - This ensures that Tailwind's styles are available in your custom stylesheet.

4. **Include the Stylesheet in Your View**:
    - Use the `stylesheet_link_tag` helper in the head of your layout or directly in the specific view to include your Tailwind stylesheet:
      ```erb
      <%= stylesheet_link_tag 'user_profile.tailwind' %>
      ```

5. **Modify Your View's HTML**:
    - Ensure the main container of your view has the ID or class you targeted in your CSS:
      ```html
      <div id="user-profile">
        <!-- Your view content -->
      </div>
      ```

6. **Precompile the New Stylesheet for Production**:
    - Add the new stylesheet to the precompile list in `config/initializers/assets.rb` for production deployment:
      ```ruby
      Rails.application.config.assets.precompile += %w( user_profile.tailwind.css )
      ```

7. **Test Your Setup**:
    - Check your view in development and production modes to ensure the background image and styles are applied correctly.

By using a Tailwind CSS file with custom sections, you get the best of both worlds: Tailwind's utility-first approach and the flexibility to add custom styles where needed. This method is particularly useful if you want to keep your Tailwind and custom styles separated or if you need to apply very specific styling that isn’t covered by Tailwind's utility classes.

---

---

---
Implementing a Ruby on Rails migration for a Kanban dashboard designed for teams involves creating the necessary database structure to support features typical of a Kanban system. A Kanban dashboard for teams might include models like `Team`, `Board`, `Column`, and `Card`. Let's break down the steps to create these migrations.

### Step 1: Plan Your Database Schema

1. **Team**: Represents different teams using the dashboard.
    - Attributes: `name`, `description`, etc.

2. **Board**: Each team can have multiple boards (e.g., for different projects).
    - Attributes: `title`, `team_id` (foreign key to `Team`).

3. **Column**: Each board can have multiple columns to represent different stages or categories (e.g., To Do, In Progress, Done).
    - Attributes: `title`, `board_id` (foreign key to `Board`), `position` (for ordering).

4. **Card**: The actual tasks/items that move through the Kanban board.
    - Attributes: `title`, `description`, `column_id` (foreign key to `Column`), `due_date`, etc.

### Step 2: Generate Migrations

Run the following commands in your terminal to generate the migrations:

```bash
rails generate migration CreateTeams name:string description:text
rails generate migration CreateBoards title:string team:references
rails generate migration CreateColumns title:string board:references position:integer
rails generate migration CreateCards title:string description:text column:references due_date:datetime
```

### Step 3: Define the Migrations

Edit the generated migration files to look something like this:

```ruby
# db/migrate/[timestamp]_create_teams.rb
class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end

# db/migrate/[timestamp]_create_boards.rb
class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.string :title
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# db/migrate/[timestamp]_create_columns.rb
class CreateColumns < ActiveRecord::Migration[6.1]
  def change
    create_table :columns do |t|
      t.string :title
      t.references :board, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end

# db/migrate/[timestamp]_create_cards.rb
class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :title
      t.text :description
      t.references :column, null: false, foreign_key: true
      t.datetime :due_date

      t.timestamps
    end
  end
end
```

### Step 4: Run the Migrations

Execute the migrations to update the database schema:

```bash
rails db:migrate
```

### Step 5: Set Up Model Associations

In your models, set up the necessary ActiveRecord associations. For example:

```ruby
# app/models/team.rb
class Team < ApplicationRecord
  has_many :boards
end

# app/models/board.rb
class Board < ApplicationRecord
  belongs_to :team
  has_many :columns
end

# app/models/column.rb
class Column < ApplicationRecord
  belongs_to :board
  has_many :cards
end

# app/models/card.rb
class Card < ApplicationRecord
  belongs_to :column
end
```

### Step 6: Add Validations (Optional)

Add validations to your models to ensure data integrity. For example, you might want to validate the presence of certain attributes:

```ruby
class Team < ApplicationRecord
  validates :name, presence: true
  # ...
end
```

### Final Notes

- Remember to customize the attributes according to the specific requirements of your application.
- You may also want to add indexes to frequently queried fields for performance optimization.
- Test your migrations and model associations to ensure everything is working as expected.

This setup gives you a basic Kanban dashboard structure, allowing teams to create boards, columns within those boards, and cards within those columns. You can further enhance and customize it based on the specific features and functionalities of your application.
