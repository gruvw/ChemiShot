local pd <const> = playdate

-- atoms are 32x32
ATOM_SIDE = 32
-- base position is (350, pd.display.getHeight())
BASE_X = 350
BASE_Y = pd.display.getHeight() - ATOM_SIDE

TOWERS = {
    {
        AtomSprite(BASE_X, BASE_Y, 'H'),
        AtomSprite(BASE_X - ATOM_SIDE, BASE_Y, 'H')
    },
    {
        AtomSprite(BASE_X, BASE_Y, 'H'),
        AtomSprite(BASE_X, BASE_Y - ATOM_SIDE, 'H'),
        AtomSprite(BASE_X - ATOM_SIDE, BASE_Y, 'C'),
        AtomSprite(BASE_X - ATOM_SIDE, BASE_Y - ATOM_SIDE, 'C')
    },
    {
        AtomSprite(BASE_X, BASE_Y, 'H'),
        AtomSprite(BASE_X - ATOM_SIDE, BASE_Y, 'H'),
        AtomSprite(BASE_X - 2 * ATOM_SIDE, BASE_Y, 'H'),
        AtomSprite(BASE_X, BASE_Y - ATOM_SIDE, 'C'),
        AtomSprite(BASE_X - ATOM_SIDE, BASE_Y - ATOM_SIDE, 'O'),
        AtomSprite(BASE_X - 2 * ATOM_SIDE, BASE_Y - ATOM_SIDE, 'C'),
        AtomSprite(BASE_X - 5, BASE_Y - 2 * ATOM_SIDE, 'H'),
        AtomSprite(BASE_X - ATOM_SIDE, BASE_Y - 2.5 * ATOM_SIDE, 'H'),
        AtomSprite(BASE_X - 2 * ATOM_SIDE + 5, BASE_Y - 2 * ATOM_SIDE, 'H')
    }
}