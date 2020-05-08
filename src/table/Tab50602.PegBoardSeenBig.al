table 50602 "Peg Board Seen Big"
{
    Caption = 'Peg Solitare';

    fields
    {
        field(1; "Game No."; Integer)
        {
            Caption = 'Game No.';
        }
        field(2; "Big Signature"; BigInteger)
        {
            Caption = 'Signature';
        }
    }

    keys
    {
        key(PK; "Game No.", "Big Signature")
        {
            Clustered = true;
        }
    }
}