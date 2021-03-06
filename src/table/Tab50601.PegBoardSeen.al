table 50601 "Peg Board Seen"
{
    Caption = 'Peg Solitare';
    ObsoleteState = Pending;
    ObsoleteReason = 'Using BigInteger. Use "Peg Board Seen Big"';

    fields
    {
        field(1; "Game No."; Integer)
        {
            Caption = 'Game No.';
        }
        field(2; "Signature"; Integer)
        {
            Caption = 'Signature';
        }
    }

    keys
    {
        key(PK; "Game No.", Signature)
        {
            Clustered = true;
        }
    }
}