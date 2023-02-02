def get_token(token_file=None) -> str:
    '''Return a token value either from an environvalue TOKEN
    or from the first line of the token_file.
    Raise ValueError if nothing found.
    '''

    from os import environ

    try:
        if token_file:
            with open(token_file, 'rt') as f:
                TOKEN = f.readline().strip()
        else:
            TOKEN = environ['TOKEN']
    except (FileNotFoundError, KeyError):
        TOKEN = None

    if not TOKEN:    # TODO check the pattern, not the bool value only
        raise(ValueError('No token found'))

    return TOKEN
