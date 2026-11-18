<?php

class Room extends Model
{
    protected $table = 'rooms';

    public function countAll(): int
    {
        $result = $this->queryOne('SELECT COUNT(*) AS total FROM rooms');

        return (int) ($result['total'] ?? 0);
    }
}
