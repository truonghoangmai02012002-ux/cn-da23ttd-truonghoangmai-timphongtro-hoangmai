<?php

abstract class Model
{
    protected PDO $db;
    protected $table;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    public function all(): array
    {
        return $this->query("SELECT * FROM `{$this->table}`");
    }

    public function find($id): ?array
    {
        return $this->queryOne("SELECT * FROM `{$this->table}` WHERE id = ?", [$id]);
    }

    public function delete($id): int
    {
        return $this->execute("DELETE FROM `{$this->table}` WHERE id = ?", [$id]);
    }

    public function query(string $sql, array $params = []): array
    {
        $statement = $this->db->prepare($sql);
        $statement->execute($params);

        return $statement->fetchAll();
    }

    public function queryOne(string $sql, array $params = []): ?array
    {
        $statement = $this->db->prepare($sql);
        $statement->execute($params);
        $result = $statement->fetch();

        return $result === false ? null : $result;
    }

    public function execute(string $sql, array $params = []): int
    {
        $statement = $this->db->prepare($sql);
        $statement->execute($params);

        return $statement->rowCount();
    }

    public function lastInsertId(): string
    {
        return $this->db->lastInsertId();
    }
}
