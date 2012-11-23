module TreesHelper
  # The tree positions have to be sorted by position (ASC)
  def prepare_loser_tree(tree_positions)
    tree = []

    unless tree_positions.empty?
      first_depth = depth(tree_positions[0])
      borders = prepare_borders(first_depth)
      offsets = prepare_offsets(first_depth, borders)
      
      last_line = offsets[first_depth - 1] + borders[first_depth - 1] - 1
      
      # Define each row
      0.upto(last_line) do |row|
        tree[row] = []
      end
      
      tree_positions.each do |pos|
        depth_diff = first_depth - depth(pos)
        h = height(pos)
        l = loser_line(depth_diff, h, last_line, borders, offsets)
        c = depth_diff * 2
        tree[l][c] = pos
        unless (pos.position == -2) and (pos.special == false)
          if (h % 2) == 0
            next_l = loser_line(depth_diff, h + 1, last_line, borders, offsets)
            l.downto(next_l) { |n| tree[n][c + 1] = true }
          else
            next_l = loser_line(depth_diff, h - 1, last_line, borders, offsets)
            l.upto(next_l) { |n| tree[n][c + 1] = true }
            tree[l + (next_l - l) / 2][c] = pos.game
          end
        end
      end
    end

    tree
  end

  def prepare_borders(first_depth)
    borders = [ 3, 4, 7, 8 ]
    i = 2
    while i < first_depth - 1
      borders[i + 3] = borders[i] * 2
      borders[i + 2] = borders[i + 3] - 1
      i = i + 2
    end
    borders
  end

  def prepare_offsets(first_depth, borders)
    offsets = [ 0 ]
    1.upto(first_depth) do |n|
      offsets << offsets[n - 1] + (borders[n - 1] / 2).floor
    end
    offsets
  end

  # The tree positions have to be sorted by position (DESC)
  def prepare_winner_tree(tree_positions)
    tree = []

    unless tree_positions.empty?
      first_depth = depth(tree_positions[0])
      0.upto((2 ** first_depth - 1) * 2) do |i|
        tree[i] = []
      end
      tree_positions.each do |pos|
        depth_diff = first_depth - depth(pos)
        l = winner_line(depth_diff, height(pos))
        c = depth_diff * 2
        tree[l][c] = pos
        unless pos.position == 1
          if (pos.position % 2) == 0
            next_l = winner_line(depth_diff, height(pos) + 1)
            tree[l + (next_l - l) / 2][c] = pos.game
            l.upto(next_l) do |n|
              tree[n][c + 1] = true
            end
          else
            l.downto(winner_line(depth_diff, height(pos) - 1)) do |n|
              tree[n][c + 1] = true
            end
          end
        end
      end
    end

    tree
  end

  def depth(tp)
    if tp.position > 0
      (Math.log(tp.position)/Math.log(2)).floor
    else
      if tp.special
        (Math.log(tp.position.abs)/Math.log(2)).floor * 2 - 1
      else
        (Math.log(tp.position.abs / 2)/Math.log(2)).floor * 2
      end
    end
  end

  def height(tp)
    if tp.position > 0
      tp.position - (2 ** depth(tp))
    else
      if tp.special
        (2 ** ((depth(tp) + 1) / 2 + 1) - 1) - tp.position.abs
      else
        ((2 ** (depth(tp) / 2 + 2)) - tp.position.abs - 2) / 2
      end
    end
  end

  def winner_line(depth_diff, height)
    (2 ** depth_diff - 1) + (2 ** (depth_diff + 1)) * height
  end

  def loser_line(depth_diff, height, last_line, borders, offsets)
    if depth_diff % 2 == 0
      between_space = (depth_diff == 0) ? 3 : borders[depth_diff] - 2
    else
      between_space = (depth_diff == 1) ? 2 : borders[depth_diff] - 4
    end
    last_line - offsets[depth_diff] -
    (height / 2).floor * (borders[depth_diff] + between_space) -
    (height % 2) * (borders[depth_diff] - 1)
  end
end
