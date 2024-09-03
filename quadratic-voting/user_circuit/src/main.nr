use dep::std;

global CANDIDATE_COUNT = 3;
global VOTER_COUNT = 2;

// Performed by a user who wants to vote while:
// - hiding their ballot
// - prove that they have stayed within budget
// Return the ballot commitment
fn main(token_budget: pub u32, votes: [u32; CANDIDATE_COUNT], secret: Field) -> pub Field {
    check_within_budget(token_budget, votes);
    calculate_ballot_commitment(votes, secret)
}

fn check_within_budget(token_budget: u32, votes: [u32; CANDIDATE_COUNT]) {
    let mut tokens_spent: u32 = 0;

    // calculate tokens_spent for an array of votes
    for i in 0..CANDIDATE_COUNT {
        let votes = votes[i];
        tokens_spent += votes * votes;
    }

    // check tokens_spent <= token_budget
    assert(tokens_spent <= token_budget);
}

// Hashes the contents of a ballot with a secret
fn calculate_ballot_commitment(votes: [u32; CANDIDATE_COUNT], secret: Field) -> Field {
    let mut transcript: [Field; CANDIDATE_COUNT + 1] = [0; CANDIDATE_COUNT + 1];

    transcript[0] = secret;
    for i in 0..CANDIDATE_COUNT {
        transcript[i + 1] = votes[i] as Field;
    }

    std::hash::pedersen_hash(transcript)
}
